<?php
    /*
     * get_email_address_by_id(): Look up an e-mail address by
     *                            its ID.
     */
    function get_email_address_by_id($address_id)
    {
        global $dbh;

        $email = "";
        $sth = $dbh->prepare("SELECT email FROM users WHERE id = ?");
        $res = $sth->execute(array($address_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        if ($row = $res->fetchrow()) {
            $email = $row["email"];
        }
        $sth->free();

        return $email;
    }


    /*
     * get_email_address_id(): Look up the ID of an e-mail address.
     */
    function get_email_address_id($address)
    {
        global $dbh;

        $address_id = 0;
        $sth = $dbh->prepare("SELECT id FROM users WHERE email = ?");
        $res = $sth->execute(array($address));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        if ($row = $res->fetchRow()) {
            $address_id = $row["id"];
        }
        $sth->free();

        return $address_id;
    }


    /*
     * get_email_address_owner(): Returns the ID of the user that
     *                            owns the specified e-mail address.
     */
    function get_email_address_owner($address_id)
    {
        global $dbh;

        $owner_id = 0;
        $sth = $dbh->prepare("SELECT maia_user_id FROM users WHERE id = ?");
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $res = $sth->execute(array($address_id));
        if ($row = $res->fetchRow()) {
            $owner_id = $row["maia_user_id"];
        }
        $sth->free();

        return $owner_id;
    }

    /*
     * add_policy(): Creates a new policy record for a given
     *               e-mail address.
     */
    function add_policy($email)
    {
        global $dbh;

        $policy_id = 0;
        $domain = "@" . get_domain_from_email($email);
        $sth = $dbh->prepare("SELECT virus_lover, " .
                         "spam_lover, " .
                         "banned_files_lover, " .
                         "bad_header_lover, " .
                         "bypass_virus_checks, " .
                         "bypass_spam_checks, " .
                         "bypass_banned_checks, " .
                         "bypass_header_checks, " .
                         "discard_viruses, " .
                         "discard_spam, " .
                         "discard_banned_files, " .
                         "discard_bad_headers, " ."spam_modifies_subj, " .
                         "spam_tag_level, " .
                         "spam_tag2_level, " .
                         "spam_kill_level " .
                  "FROM policy WHERE policy_name = ?");

        // Try to find a domain-based set of defaults for this user,
        // based on his e-mail address.
        $res = $sth->execute(array($domain));
        if ($row = $res->fetchRow()) {
            $virus_lover = $row["virus_lover"];
            $spam_lover = $row["spam_lover"];
            $bad_header_lover = $row["bad_header_lover"];
            $banned_files_lover = $row["banned_files_lover"];
            $bypass_virus_checks = $row["bypass_virus_checks"];
            $bypass_spam_checks = $row["bypass_spam_checks"];
            $bypass_banned_checks = $row["bypass_banned_checks"];
            $bypass_header_checks = $row["bypass_header_checks"];
            $discard_viruses = $row["discard_viruses"];
            $discard_spam = $row["discard_spam"];
            $discard_banned_files = $row["discard_banned_files"];
            $discard_bad_headers = $row["discard_bad_headers"];
            $spam_modifies_subj = $row["spam_modifies_subj"];
            $spam_tag_level = $row["spam_tag_level"];
            $spam_tag2_level = $row["spam_tag2_level"];
            $spam_kill_level = $row["spam_kill_level"];
            $nodefault = false;
        } else {

            // Try to find a "Default" policy (@.) to copy defaults from.
            $res = $sth->execute(array("Default"));
            if ($row = $res->fetchRow()) {
                $virus_lover = $row["virus_lover"];
                $spam_lover = $row["spam_lover"];
                $bad_header_lover = $row["bad_header_lover"];
                $banned_files_lover = $row["banned_files_lover"];
                $bypass_virus_checks = $row["bypass_virus_checks"];
                $bypass_spam_checks = $row["bypass_spam_checks"];
                $bypass_banned_checks = $row["bypass_banned_checks"];
                $bypass_header_checks = $row["bypass_header_checks"];
                $discard_viruses = $row["discard_viruses"];
                $discard_spam = $row["discard_spam"];
                $discard_banned_files = $row["discard_banned_files"];
                $discard_bad_headers = $row["discard_bad_headers"];
                $spam_modifies_subj = $row["spam_modifies_subj"];
                $spam_tag_level = $row["spam_tag_level"];
                $spam_tag2_level = $row["spam_tag2_level"];
                $spam_kill_level = $row["spam_kill_level"];
                $nodefault = false;
            } else {

              // No suitable defaults found.
              $nodefault = true;
            }
        }
        $sth->free();

        if ($nodefault) {

            // Use the database defaults as our last resort.
            $sth = $dbh->prepare("INSERT INTO policy (policy_name) VALUES (?)");
            $sth->execute(array($email));
            if (PEAR::isError($sth)) {
                die($sth->getMessage());
            }
            $sth->free();

        } else {

            // Use the domain or system default values found above.
            $sth = $dbh->prepare("INSERT INTO policy (policy_name, " .
                                          "virus_lover, " .
                                          "spam_lover, " .
                                          "banned_files_lover, " .
                                          "bad_header_lover, " .
                                          "bypass_virus_checks, " .
                                          "bypass_spam_checks, " .
                                          "bypass_banned_checks, " .
                                          "bypass_header_checks, " .
                                          "discard_viruses, " .
                                          "discard_spam, " .
                                          "discard_banned_files, " .
                                          "discard_bad_headers, " .
                                          "spam_modifies_subj, " .
                                          "spam_tag_level, " .
                                          "spam_tag2_level, " .
                                          "spam_kill_level" .
                      ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
            $sth->execute(array($email,
                                       $virus_lover,
                                       $spam_lover,
                                       $banned_files_lover,
                                       $bad_header_lover,
                                       $bypass_virus_checks,
                                       $bypass_spam_checks,
                                       $bypass_banned_checks,
                                       $bypass_header_checks,
                                       $discard_viruses,
                                       $discard_spam,
                                       $discard_banned_files,
                                       $discard_bad_headers,
                                       $spam_modifies_subj,
                                       $spam_tag_level,
                                       $spam_tag2_level,
                                       $spam_kill_level));
            if (PEAR::isError($sth)) {
                die($sth->getMessage());
            }
            $sth->free();
        }

        $sth = $dbh->prepare("SELECT id FROM policy WHERE policy_name = ?");
        $res = $sth->execute(array($email));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        if ($row = $res->fetchRow()) {
            $policy_id = $row["id"];
        }
        $sth->free();

        return $policy_id;
    }


    /*
     * delete_policy(): Deletes the specified policy record.
     */
    function delete_policy($policy_id)
    {
        global $dbh;

        $sth = $dbh->prepare("DELETE FROM policy WHERE id = ?");
        $sth->execute(array($policy_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $sth->free();
    }


    /*
     * delete_email_address(): Deletes the specified e-mail address.
     */
    function delete_email_address($address_id)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT policy_id " .
                  "FROM users " .
                  "WHERE id = ?");
        $res = $sth->execute(array($address_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        if ($row = $res->fetchRow()) {
            delete_policy($row["policy_id"]);
            $sth2 = $dbh->prepare("DELETE FROM users WHERE id = ?");
            $sth2->execute(array($address_id));
            if (PEAR::isError($sth2)) {
                die($sth2->getMessage());
            }
            $sth2->free();
        }
        $sth->free();
    }


    /*
     * smart_delete_email_address(): Deletes the specified e-mail address.
     * intelligently delete maia_users here if only address
     */
    function smart_delete_email_address($address_id)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT users.id AS address_id, users.policy_id, users.maia_user_id, maia_users.user_name, maia_users.primary_email_id " .
                   "FROM users, maia_users " .
                   "WHERE users.maia_user_id = maia_users.id " .
                   "AND users.id = ?");
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $res = $sth->execute(array($address_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }

        if ($row = $res->fetchRow()) {
            # was this address the owner's primary address?
            if ($row['address_id'] == $row['primary_email_id']) {
                # yes - does the address owner own any other addresses?
                $sth2 = $dbh->prepare("SELECT COUNT(id) AS idcount FROM users WHERE maia_user_id = ? AND id <> ?");
                $res2 = $sth2->execute(array($row['maia_user_id'], $row['address_id']));
                if (PEAR::isError($sth2)) {
                    die($sth2->getMessage());
                }  
                $row2 = $res2->fetchrow();
                if($row2['idcount'] <> 0) {
                  #yes - we can't go on with this, unless we add an override option too.
                  return false;
                }  else {
                  #no, it's the only address, go ahead and remove user too.
                  delete_user($row['maia_user_id']);
                }
            $sth2->free();
            } else {
                #not the primary email address, just remove the address.
                #no need to delete anything else, until per-address is in effect
                delete_policy($row["policy_id"]);
                $sth2 = $dbh->prepare("DELETE FROM users WHERE id = ?");
                $sth2->execute(array($address_id));
                if (PEAR::isError($sth)) {
                    die($sth->getMessage());
                }
                $sth2->free();
            }
            return true;
        }
        $sth->free();
        return false;
    }


    /*
     * delete_user_email_addresses(): Deletes all of the e-mail addresses
     *                                that belong to the specified user.
     */
    function delete_user_email_addresses($uid)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT id FROM users WHERE maia_user_id = ?");
        $res = $sth->execute(array($uid));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        while ($row = $res->fetchRow()) {
            delete_email_address($row["id"]);
        }
        $sth->free();
    }
