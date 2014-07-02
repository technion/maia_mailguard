<?php
    /*
     * $Id: adminusers.php 1439 2009-11-17 23:31:04Z dmorton $
     *
     * MAIA MAILGUARD LICENSE v.1.0
     *
     * Copyright 2004 by Robert LeBlanc <rjl@renaissoft.com>
     *                   David Morton   <mortonda@dgrmm.net>
     * All rights reserved.
     *
     * PREAMBLE
     *
     * This License is designed for users of Maia Mailguard
     * ("the Software") who wish to support the Maia Mailguard project by
     * leaving "Maia Mailguard" branding information in the HTML output
     * of the pages generated by the Software, and providing links back
     * to the Maia Mailguard home page.  Users who wish to remove this
     * branding information should contact the copyright owner to obtain
     * a Rebranding License.
     *
     * DEFINITION OF TERMS
     *
     * The "Software" refers to Maia Mailguard, including all of the
     * associated PHP, Perl, and SQL scripts, documentation files, graphic
     * icons and logo images.
     *
     * GRANT OF LICENSE
     *
     * Redistribution and use in source and binary forms, with or without
     * modification, are permitted provided that the following conditions
     * are met:
     *
     * 1. Redistributions of source code must retain the above copyright
     *    notice, this list of conditions and the following disclaimer.
     *
     * 2. Redistributions in binary form must reproduce the above copyright
     *    notice, this list of conditions and the following disclaimer in the
     *    documentation and/or other materials provided with the distribution.
     *
     * 3. The end-user documentation included with the redistribution, if
     *    any, must include the following acknowledgment:
     *
     *    "This product includes software developed by Robert LeBlanc
     *    <rjl@renaissoft.com>."
     *
     *    Alternately, this acknowledgment may appear in the software itself,
     *    if and wherever such third-party acknowledgments normally appear.
     *
     * 4. At least one of the following branding conventions must be used:
     *
     *    a. The Maia Mailguard logo appears in the page-top banner of
     *       all HTML output pages in an unmodified form, and links
     *       directly to the Maia Mailguard home page; or
     *
     *    b. The "Powered by Maia Mailguard" graphic appears in the HTML
     *       output of all gateway pages that lead to this software,
     *       linking directly to the Maia Mailguard home page; or
     *
     *    c. A separate Rebranding License is obtained from the copyright
     *       owner, exempting the Licensee from 4(a) and 4(b), subject to
     *       the additional conditions laid out in that license document.
     *
     * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
     * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
     * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
     * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
     * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
     * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
     * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
     * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
     * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
     * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
     * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
     *
     */

    require_once ("core.php");
    require_once ("maia_db.php");
    require_once ("authcheck.php");
    require_once ("display.php");
    $display_language = get_display_language($euid);
    require_once ("./locale/$display_language/db.php");
    require_once ("./locale/$display_language/display.php");
    require_once ("./locale/$display_language/adminusers.php");

    require_once ("smarty.php");
    
    // Only administrators should be here.
    if (!is_an_administrator($uid)) {
       header("Location: index.php" . $sid);
       exit();
    }

    // Cancel any impersonations currently in effect
    // by resetting EUID = UID and forcing a reload
    // of this page.
    if ($uid != $euid) {
       $euid = $uid;
       $_SESSION["euid"] = $uid;
       header("Location: adminusers.php" . $sid);
       exit();
    }

    // Is this administrator the superadmin, or just a
    // domain admin?
    $super = is_superadmin($uid);

    $domain_name = array();
    $address = array();
    $user = array();
    if (!$super) {

    	// Make a list of the domains this administrator can access.
        $select = "SELECT domain " .
                  "FROM maia_domains, maia_domain_admins " .
                  "WHERE maia_domains.id = maia_domain_admins.domain_id " .
                  "AND maia_domain_admins.admin_id = ? " .
                  "ORDER BY domain ASC";
        $sth = $dbh->query($select, array($uid));
        while ($row = $sth->fetchrow()) {
            $domain_name[] =  strtolower($row["domain"]);
        }
        $smarty->assign('domain_name', $domain_name);
        $sth->free();

        foreach ($domain_name as $dname) {

            // List only the e-mail addresses within the
            // domains administered by this admin.
            $select = "SELECT users.email, users.id " .
                      "FROM users, maia_users " .
                      "WHERE users.email LIKE '%_" . $dname . "' " .
                      "AND users.maia_user_id = maia_users.id " .
                      "AND (maia_users.user_level = 'U' " .
                      "OR maia_users.id = ?) " .
                      "ORDER BY users.email ASC";
            $sth = $dbh->query($select, array($uid));
           
            while ($row = $sth->fetchrow()) {
                $address[$row["email"]] = $row["id"];
            }
            $sth->free();
        }

        

        
        foreach ($domain_name as $dname) {

            // List only the users with e-mail addresses within the
            // domains administered by this admin.
            $select = "SELECT DISTINCT maia_users.user_name, maia_users.id " .
                      "FROM maia_users, users " .
                      "WHERE maia_users.id = users.maia_user_id " .
                      "AND users.email LIKE '%" . $dname . "' " .
                      "AND (maia_users.user_level = 'U' " .
                      "OR maia_users.id = ?) " .
                      "ORDER BY user_name ASC";
            $sth = $dbh->query($select, array($uid));
            while ($row = $sth->fetchrow()) {
            if (is_a_domain_default_user($row["id"])) {
              continue;
            }
                $user[$row["user_name"]] = $row["id"];
            }
            $sth->free();
        }
    } else {

    	// The superadmin can list all e-mail addresses in all domains.
        $select = "SELECT email, id " .
                  "FROM users " .
                  "WHERE email NOT LIKE '@%' " .
                  "ORDER BY email ASC";
        $sth = $dbh->query($select);
        $address = array();
        while ($row = $sth->fetchrow()) {
            $address[$row["email"]] = $row["id"];
        }
        $sth->free();

    	// The superadmin can list all users in all domains.
        $select = "SELECT user_name, id " .
                  "FROM maia_users " .
                  "ORDER BY user_name ASC";
        $sth = $dbh->query($select);
        $user = array();
        while ($row = $sth->fetchrow()) {
            if (is_a_domain_default_user($row["id"])) {
              continue;
            }
            $user[$row["user_name"]] = $row["id"];
        }
        $sth->free();

    }
    ksort($address);
    $smarty->assign('address', $address);
    ksort($user);
    $smarty->assign('user', $user);

    $smarty->assign('addresses', count($address));
    $smarty->assign('users', count($user));

    $delete_address = array();
    if (!$super) {

        foreach ($domain_name as $dname) {

            // List only the e-mail addresses within the
            // domains administered by this admin.
            $select = "SELECT users.email, users.id " .
                      "FROM users, maia_users " .
                      "WHERE users.email LIKE '%_" . $dname . "' " .
                      "AND users.maia_user_id = maia_users.id " .
                      "AND maia_users.user_level = 'U' " .
                      "ORDER BY users.email ASC";
            $sth = $dbh->query($select);
            while ($row = $sth->fetchrow()) {
                $delete_address[$row["email"]] = $row["id"];
            }
            $sth->free();
        }

    } else {

    	// The superadmin can list all e-mail addresses in all domains.
        $select = "SELECT email, id " .
                  "FROM users " .
                  "WHERE email NOT LIKE '@%' " .
                  "ORDER BY email ASC";
        $sth = $dbh->query($select);
        $delete_address = array();
        while ($row = $sth->fetchrow()) {
            $delete_address[$row["email"]] = $row["id"];
        }
        $sth->free();
    }
    ksort($delete_address);
    $smarty->assign('delete_address', $delete_address);
    $smarty->assign('delete_addresses', count($delete_address));
    

    $del_user = array();
    if (!$super) {

        foreach ($domain_name as $dname) {

            // List only the users with e-mail addresses within the
            // domains administered by this admin.
            $select = "SELECT DISTINCT maia_users.user_name, maia_users.id " .
                      "FROM maia_users, users " .
                      "WHERE maia_users.id = users.maia_user_id " .
                      "AND users.email LIKE '%_" . $dname . "' " .
                      "AND maia_users.user_level = 'U' " .
                      "ORDER BY user_name ASC";
            $sth = $dbh->query($select);
            while ($row = $sth->fetchrow()) {
                $del_user[$row["user_name"]] = $row["id"];
            }
            $sth->free();
        }

    } else {

    	// The superadmin can list all users in all domains.
        $select = "SELECT user_name, id " .
                  "FROM maia_users " .
                  "WHERE user_level <> 'S' " .
                  "AND user_name NOT LIKE '@%' " .
                  "ORDER BY user_name ASC";
        $sth = $dbh->query($select);
            $del_user = array();
            while ($row = $sth->fetchrow()) {
                $del_user[$row["user_name"]] = $row["id"];
            }
        $sth->free();

    }
    ksort($del_user);
    $smarty->assign('del_user', $del_user);
    $smarty->assign('del_users', count($del_user));

    $smarty->display('adminusers.tpl');
    
?>
