<?php
    /*
     * get_domain_id(): Looks up a domain name (in @domain format)
     *                  and returns its id if found, 0 otherwise.
     */
    function get_domain_id($domain_name)
    {
        global $dbh;

        $domain_id = 0;
        $select = "SELECT id FROM maia_domains WHERE domain = ?";
        $sth = $dbh->query($select, array(strtolower($domain_name)));
        if ($row = $sth->fetchrow()) {
            $domain_id = $row["id"];
        }
        $sth->free();

        return $domain_id;
    }


    /*
     * is_admin_for_domain(): Returns true if the specified user
     *                        has administrator privileges for
     *                        the specified domain, false otherwise.
     */
    function is_admin_for_domain($uid, $domain_id)
    {
        global $dbh;

        $user_level = get_user_level($uid);

        if ($user_level == "S") {
            return true;
        } else {
            $select = "SELECT maia_users.user_level " .
                      "FROM maia_users, maia_domain_admins " .
                      "WHERE maia_users.id = ? " .
                      "AND maia_users.id = maia_domain_admins.admin_id " .
                      "AND maia_domain_admins.domain_id = ?";

            $sth = $dbh->query($select, array($uid, $domain_id));
            if ($row = $sth->fetchrow()) {
                $result = ($row["user_level"] == "A");
            } else {
                $result = false;
            }
            $sth->free();

            return $result;
        }
    }

    /*
     *
     * get_default_domain_policies():  Gets default policies for autocreation and domain transports from @.
     *                Returns a named array: ['autocreation'=>boolean, 'transport'=>string]
     */
    function get_default_domain_policies() {
        global $dbh;

        $query = "SELECT enable_user_autocreation, transport FROM maia_domains WHERE domain = '@.'";
        $sth = $dbh->query($query);
        if ($row = $sth->fetchrow()) {
            $policy = $row["enable_user_autocreation"];
            $transport = $row['transport'];
        } else {
            $policy = false;
            $transport = ':';
        }
        $sth->free();
        return array('autocreation' => $policy, 'transport' => $transport);
    }

    /*
     *
     * get_autocreation_policy():  Gets autocreation policy for given domain
     *                Returns 'Y' or 'N', or false on error.
     */
    function get_autocreation_policy($domain) {
        global $dbh;

        $query = "SELECT enable_user_autocreation FROM maia_domains WHERE domain = ?";
        $sth = $dbh->query($query, array($domain));
        if ($row = $sth->fetchrow()) {
            $policy = $row["enable_user_autocreation"];
        } else {
            $policy = false;
        }
        $sth->free();
        return $policy;
    }

     /*
     *
     * get_autocreation_policy():  Sets autocreation policy for given domain
     *
     */
    function set_autocreation_policy($domain, $policy) {
        global $dbh;

        $query = "UPDATE maia_domains SET enable_user_autocreation=? FROM maia_domains WHERE domain = ?";
        $sth = $dbh->query($query, array($policy, $domain));
    }

    /*
     *
     * add_domain():  adds a domain default account.
     *                Copies defaults in from system default.
     */
    function add_domain($domain_name) {
        global $dbh;
        global $logger;

        if (get_domain_id($domain_name) != 0) {
            $logger->warning("Attempt to add duplicate domain:" . $domain_name);
            return 0;
        }

        // get default autocreation policy
        $default_policies            = get_default_domain_policies();
        $default_autocreation_policy = $default_policies['autocreation'];
        $default_transport           = $default_policies['transport'];
        $routing_domain              = substr($domain_name,1);

        // Add the domain to the maia_domains table
        $insert = "INSERT INTO maia_domains (domain, enable_user_autocreation, routing_domain, transport) VALUES (?,?,?,?)";
        $dbh->query($insert, array($domain_name, $default_autocreation_policy,$routing_domain,$default_transport));
        $select = "SELECT id FROM maia_domains WHERE domain = ?";
        $sth = $dbh->query($select, array($domain_name));
        if ($row = $sth->fetchrow()) {
            $domain_id = $row["id"];
        }
        $sth->free();

        // Add a new policy for the domain, based on the
        // system defaults.
        $policy_id = add_policy($domain_name);
        // Add the domain address to the users table
        $primary_email_id = add_address_to_user($policy_id, $domain_name, 0, $domain_id);

        $default_user_config = get_maia_user_row(get_user_id("@.", "@."));

        // Add a domain default user to the maia_users table
        $insert = "INSERT INTO maia_users (user_name, primary_email_id, reminders, discard_ham, theme_id) VALUES (?, ?, 'N', ?, ?)";
        $dbh->query($insert, array($domain_name,
                                   $primary_email_id,
                                   $default_user_config["discard_ham"],
                                   $default_user_config["theme_id"]
                                   ));
        $select = "SELECT id FROM maia_users WHERE user_name = ?";
        $sth = $dbh->query($select, array($domain_name));
        if ($row = $sth->fetchrow()) {
            $maia_user_id = $row["id"];
        }
        $sth->free();

        // Update the users table to link the e-mail address back to the domain
        $update = "UPDATE users SET maia_user_id = ? WHERE id = ?";
        $dbh->query($update, array($maia_user_id, $primary_email_id));

        return $domain_id;
    }

    /*
     * delete_domain_admin_references(): Deletes all administrator references
     *                                   to the specified domain.
     */
    function delete_domain_admin_references($domain_id)
    {
        global $dbh;

        // List all the administrators that reference the target domain.
        $select = "SELECT admin_id FROM maia_domain_admins WHERE domain_id = ?";
        $sth = $dbh->query($select, array($domain_id));
        sql_check($sth,"delete_domain_admin_references",$select);
        while ($row = $sth->fetchrow()) {
            $admin_id = $row["admin_id"];

            // Delete this admin's reference to the target domain.
            $delete = "DELETE FROM maia_domain_admins WHERE domain_id = ? AND admin_id = ?";
            $res = $dbh->query($delete, array($domain_id, $admin_id));
            sql_check($res,"delete_domain_admin_references",$delete);

            // Does this admin administer any other domains?
            $select = "SELECT domain_id FROM maia_domain_admins WHERE admin_id = ?";
            $sth2 = $dbh->query($select, array($admin_id));
            sql_check($sth2,"delete_domain_admin_references",$select);
            if (!$sth2->fetchrow()) {

                // This admin no longer administers any domains, so
                // return his privilege level to that of a normal user.
                $update = "UPDATE maia_users SET user_level = 'U' WHERE id = ?";
                $res = $dbh->query($update, array($admin_id));
                sql_check($res,"delete_domain_admin_references",$update);
            }
            $sth2->free();
        }
        $sth->free();
    }


    /*
     * delete_domain(): Deletes the specified domain and all administrator
     *                  references to it.
     */
    function delete_domain($domain_id)
    {
        global $dbh;

        // Delete all admin references to this domain.
        delete_domain_admin_references($domain_id);

        // Delete the domain record itself.
        $delete = "DELETE FROM maia_domains WHERE id = ?";
        $res = $dbh->query($delete, array($domain_id));
        sql_check($res,"delete_domain",$delete);

        // Find and delete the default user records associated with this domain
        $select = "SELECT maia_user_id FROM users WHERE maia_domain_id = ?";
        $sth = $dbh->query($select, array($domain_id));
        sql_check($sth,"delete_domain",$select);
        if ($row = $sth->fetchrow()) {
            $maia_user_id = $row["maia_user_id"];
            delete_user($maia_user_id);
        }
        $sth->free();
    }
