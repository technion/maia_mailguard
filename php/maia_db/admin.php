<?php
    /*
     * is_an_administrator(): Returns true if the specified user is
     *                        the superadministrator or the admin
     *                        of one or more domains, false otherwise.
     */
    function is_an_administrator($uid)
    {
      $user_level = get_user_level($uid);

      return ($user_level == "A" || $user_level == "S");
    }


    /*
     * is_superadmin(): Returns true if the specified user is the
     *                  superadministrator, false otherwise.
     */
    function is_superadmin($uid)
    {
        $user_level = get_user_level($uid);

        return ($user_level == "S");
    }


    /*
     * get_superadmin_id(): Returns the Maia user ID of the
     *                      superadministrator, or 0 if no one has
     *                      superadministrator privileges.
     */
    function get_superadmin_id()
    {
        global $dbh;

        $super_id = 0;
        $select = "SELECT id FROM maia_users WHERE user_level = 'S'";
        $sth = $dbh->query($select);
        if ($row = $sth->fetchRow()) {
            $super_id = $row["id"];
        }
        $sth->free();

        return $super_id;
    }


    /*
     * set_superadmin_id(): Makes the specified user the superadministrator.
     */
    function set_superadmin_id($uid)
    {
        global $dbh;

        if (get_superadmin_id() == 0) {
            $sth = $dbh->prepare("UPDATE maia_users SET user_level = 'S' " .
                      "WHERE id = ?");
            $sth->execute(array($uid));
            if (PEAR::isError($sth)) {
                die($sth->getMessage());
            }
            $sth->free();
            return true;
        } else {
            return false;
        }
    }


    /*
     * unset_superadmin_id(): Demotes the current superadministrator to
     *                        regular (U)ser status.
     */
    function unset_superadmin_id($uid)
    {
        global $dbh;

        $super_id = get_superadmin_id();
        if ($super_id == $uid) {
            $sth = $dbh->prepare("UPDATE maia_users SET user_level = 'U' " .
                      "WHERE id = ?");
            $sth->execute(array($uid));
            if (PEAR::isError($sth)) {
                die($sth->getMessage());
            }
            $sth->free();
            return true;
        } else {
            return false;
        }
    }
