<?php

    /*
     * get_wb_status(): Returns 'W' if a given e-mail address appears in a given user's
     *                  whitelist, 'B' if it appears in the user's blacklist, or '' otherwise.
     */
    function get_wb_status($user_id, $addr_id)
    {
        global $dbh;

        $wb = '';
        $select = "SELECT wb " .
                 "FROM wblist " .
                 "WHERE rid = ? " .
                 "AND sid = ?";
        $sth = $dbh->query($select, array($user_id, $addr_id));
        if ($row = $sth->fetchRow()) {
            $wb = $row["wb"];
        }
        $sth->free();

        return $wb;
    }


    /*
     * set_wb_status(): Changes the status ('W' or 'B') of an entry in a given user's
     *                  whitelist/blacklist.
     */
    function set_wb_status($user_id, $addr_id, $wb)
    {
        global $dbh;
        global $logger;

        $update = "UPDATE wblist SET wb = ? WHERE rid = ? AND sid = ?";
        $result = $dbh->query($update, array($wb, $user_id, $addr_id));
        if (PEAR::isError($result)) {
            $logger->err("Problem updating wblist: " . $result->getMessage());
            return 'text_wblist_error';
        } else {
            return 'text_lists_updated';
        }
    }


    /*
    * add_wb_entry(): Adds a new entry to a user's whitelist/blacklist.
    */
    function add_wb_entry($user_id, $addr_id, $wb)
    {
        global $dbh;

        $insert = "INSERT INTO wblist (rid, sid, wb) VALUES (?, ?, ?)";
        $dbh->query($insert, array($user_id, $addr_id, $wb));
    }


    /*
    * delete_wb_entry(): Removes an entry from a user's whitelist/blacklist.
    */
    function delete_wb_entry($user_id, $addr_id)
    {
        global $dbh;

        $delete = "DELETE FROM wblist WHERE rid = ? AND sid = ?";
        $result = $dbh->query($delete, array($user_id, $addr_id));
        if (PEAR::isError($result)) {
            $logger->err("Problem deleting wblist: " . $result->getMessage());
            return $lang['text_wblist_error'];
        }

        // If there are no other references to this address,
        // remove it from the mailaddr table as well.
        $select = "SELECT wb FROM wblist WHERE sid = ?";
        $sth2 = $dbh->query($select, array($addr_id));
        if (!$sth2->fetchRow()) {
            $delete = "DELETE FROM mailaddr WHERE id = ?";
            $result = $dbh->query($delete, array($addr_id));
            if (PEAR::isError($result)) {
                $logger->err("Problem updating wblist: " . $result->getMessage());
                return $lang['text_wblist_error'];
            }
        }
        $sth2->free();
        return 'text_wb_deleted';
    }


    /*
    * delete_user_wb_entries(): Removes all entries from a user's whitelist/blacklist.
    */
    function delete_user_wb_entries($user_id)
    {
        global $dbh;

        $select = "SELECT sid " .
                 "FROM wblist " .
                 "WHERE rid = ?";
        $sth = $dbh->query($select, array($user_id));
        while ($row = $sth->fetchRow()) {
            delete_wb_entry($user_id, $row["sid"]);
        }
        $sth->free();
    }


    /*
    * add_address(): Adds a new e-mail address to the mailaddr table.
    *                Note: Assumes that address is either in "user@domain" form
    *                      or "@domain" form.  i.e. call fix_address() first.
    */
    function add_address($email)
    {
        global $dbh;

        $addr_id = 0;
        $priority = get_email_address_priority($email);
        $insert = "INSERT INTO mailaddr (priority, email) VALUES (?, ?)";

        $dbh->query($insert, array($priority, $email));

        $select = "SELECT id FROM mailaddr WHERE email = ?";

        $sth = $dbh->query($select, array($email));
        if ($row = $sth->fetchRow()) {
            $addr_id = $row["id"];
        }
        $sth->free();

        return $addr_id;
    }


    /*
     * get_address_id(): Looks up the ID number of an e-mail address in
     *                   the mailaddr table.
     */
    function get_address_id($addr)
    {
        global $dbh;
        
        $select = "SELECT id FROM mailaddr WHERE email = ?";
        
        $addr_id = 0;
        $sth = $dbh->query($select, array($addr));
        if ($row = $sth->fetchRow()) {
            $addr_id = $row["id"];
        }
        $sth->free();
        
        return $addr_id;
    }


    /*
     * add_address_to_wb_list(): Adds an e-mail address to a user's
     *                           whitelist/blacklist, if necessary.
     *     returns message code, use to match with locale strings.
     */
    function add_address_to_wb_list($user_id, $addr, $wb)
    {
        global $dbh;
        $matches = array();
        # look for an email address of the form <user@domain>
        if (preg_match('/<(\S+\@\S+\.\S+)>/', $addr, $matches) > 0 ) {
            $addr = $matches[1];
        }

        # if that fails, look for user@domain
        elseif (preg_match("/(\S+\@\S+\.\S+)/", $addr, $matches) > 0 ) {
            $addr = $matches[1];
        }

        $addr = fix_address($addr);
        $addr_id = get_address_id($addr);
        if (substr($addr, 0, 1) == '@') {
            $addr = "*" . $addr;
        }
        if ($addr_id == 0) {
            $addr_id = add_address($addr);
            add_wb_entry($user_id, $addr_id, $wb);
            return 'text_wb_address_added';
        } else {
            $wb_stat = get_wb_status($user_id, $addr_id);
            if ($wb_stat == '') {
                add_wb_entry($user_id, $addr_id, $wb);
                return 'text_wb_address_added';
            } else {
                if ($wb_stat != $wb) {
                    set_wb_status($user_id, $addr_id, $wb);
                }
                return 'text_wb_address_changed';
            }
        }
    }
