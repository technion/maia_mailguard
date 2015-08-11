<?php
    /*
     * get_config_value(): Returns the value corresponding to a single
     *                     key from the system configuration table.  This
     *                     is a convenient way to read one configuration
     *                     setting, but if multiple configuration settings
     *                     are required, it becomes more efficient to
     *                     use a manual query, rather than calling this
     *                     function repeatedly.
     */
    function get_config_value($key)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT " . $key . " FROM maia_config WHERE id = 0");
        $res = $sth->execute();
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }

        if ($row = $res->fetchrow()) {
            $value = $row[$key];
        }
        $sth->free();
        return $value;
    }


    function get_database_type($dbh)
    {
        return $dbh->phptype;
    }

    /*
     * generate_random_password(): Generates an 8-character alphanumeric
     *                             password, and returns both the password
     *                             and its corresponding MD5 hash.
     */
    function generate_random_password()
    {
        $password_length = 8;

        for ($i = "A"; $i < "Z"; $i++) {
            $chars[] = $i;
        }
        for ($i = "a"; $i < "z"; $i++) {
            $chars[] = $i;
        }
        for ($i = "0"; $i < "9"; $i++) {
            $chars[] = $i;
        }

        $password = "";
        for ($i = 0; $i < $password_length; $i++) {
            $password .= $chars[mt_rand(0, count($chars)-1)];
        }
        $digest = md5($password);

        return array($password, $digest);
    }


    function get_chart_colors() {
        global $dbh;

        $sth = $dbh->prepare("SELECT chart_suspected_ham_colour AS sh, chart_ham_colour AS h, chart_wl_colour as wl, " .
                          "chart_bl_colour as bl, chart_suspected_spam_colour as ss, chart_spam_colour as s, " .
                          "chart_fp_colour as fp, chart_fn_colour as fn, chart_virus_colour as v " .
                  "FROM maia_config WHERE id=0");

        $res = $sth->execute();
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }

        if ($row = $res->fetchrow()) {
            $value = $row;
        }
        $sth->free();

        $value["bf"] = "#C9BBFF";
        $value["bh"] = "#FFCC79";
        $value["os"] = "#FF8080";

        return $value;
    }


    function Pager_Wrapper_DB(&$db, $query, $pager_options = array(), $disabled = false, $fetchMode = MDB2_FETCHMODE_ASSOC, $dbparams = null)
    {
        $db->setFetchMode($fetchMode);
        if (!array_key_exists('totalItems', $pager_options)) {
            //  be smart and try to guess the total number of records
            if ($countQuery = rewriteCountQuery($query)) {
                $totalItems = $db->getOne($countQuery, $dbparams);
                if (PEAR::isError($totalItems)) {
                    return $totalItems;
                }
            } else {
                $res =& $db->query($query, $dbparams);
                if (PEAR::isError($res)) {
                    return $res;
                }
                $totalItems = (int)$res->numRows();
                $res->free();
            }
            $pager_options['totalItems'] = $totalItems;
        }
        $pager_options['delta'] = 3;
        require_once 'Pager/Pager.php';
        $pager =& Pager::factory($pager_options);

        $page = array();
        $page['totalItems'] = $pager_options['totalItems'];
        $page['links'] = $pager->links;
        $page['page_numbers'] = array(
            'current' => $pager->getCurrentPageID(),
            'total'   => $pager->numPages()
        );
        list($page['from'], $page['to']) = $pager->getOffsetByPageId();

	if (!$disabled) {
           $db->setLimit($pager_options['perPage'], $page['from']-1);
        }
        $sth = $db->prepare($query);
        $res = $sth->execute($dbparams);
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
         
        $page['data'] = array();

        while($row = $res->fetchRow()) {
            $page['data'][] = $row;
        }
        if ($disabled) {
            $page['links'] = '';
            $page['page_numbers'] = array(
                'current' => 1,
                'total'   => 1
            );
        }

        return $page;
    }

    function sql_check($res, $function, $text="") {
        global $logger;
        if (PEAR::isError($res)) {
            $logger->err("$function  " . $res->getMessage() . " " . $text);
        }
    }

    function response_text($cache_type) {
        global $lang;
        switch($cache_type) {
          case "ham":
            return array($lang['button_confirm_ham'], $lang['button_report_spam'], $lang['button_ns_delete']);
          case "spam":
            return array($lang['button_rescue'], $lang['button_confirm_spam'], $lang['button_ns_delete']);
          case "virus":
            return array($lang['button_rescue'], $lang['button_report'], $lang['button_delete']);
          case "header":
            return array($lang['button_rescue'], $lang['button_report_spam'], $lang['button_ns_delete']);
          case "attachment":
            return array($lang['button_rescue'], $lang['button_report_spam'], $lang['button_delete']);
        }
    }

    function get_default_theme()
    {
        global $dbh;
        $sth = $dbh->prepare("SELECT theme_id FROM maia_users WHERE user_name=?");
        $res = $sth->execute(array('@.'));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        if ($row=$res->fetchrow()) {
            $default_theme_id = $row['theme_id'];
        } else {
            #ack! no default?
            $default_theme_id = false;
        }
        $sth->free();
        return $default_theme_id;
    }
