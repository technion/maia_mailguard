<?php
    /*
     * $Id: internal-init.php
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

    require_once ("../core.php");
    require_once ("../maia_db.php");
    require_once ("../display.php");
    require_once ("../smtp.php");

    // Set some default values so smarty.php doesn't choke.
    $uid = 0;
    $euid = 0;
    $msid = "";
    $sid = ""; 

    // Determine the user's language preference
    if (isset($_GET["lang"]) && strlen($_GET["lang"]) == 2 ) {
       $display_language = trim($_GET["lang"]);
    } else {
       $display_language = $default_display_language;
    }
    require_once ("../locale/$display_language/db.php");
    require_once ("../locale/$display_language/display.php");
    require_once ("../locale/$display_language/smtp.php");
    require_once ("../locale/$display_language/internal-init.php");

    require_once ("../smarty.php");
    $smarty->assign("display_language",$display_language);

    // Only show this page if we've selected internal
    // authentication and there's no current superadmin
    if (($auth_method != "internal") || (get_superadmin_id() > 0)) {
        header("Location: index.php");
        exit();
    }

    if (isset($_POST["submit"])) {
        $smarty->assign("submitted", true);
        if (isset($_POST["your_email"])) {
            $your_email = trim($_POST["your_email"]);
        } else {
            $your_email = "";
        }
        if (isset($_POST["admin_email"])) {
            $admin_email = trim($_POST["admin_email"]);
        } else {
            $admin_email = "";
        }
        if (isset($_POST["reminder_login_url"])) {
            $reminder_login_url = trim($_POST["reminder_login_url"]);
        } else {
            $reminder_login_url = "";
        }
        if (isset($_POST["newuser_template_file"])) {
            $newuser_template_file = trim($_POST["newuser_template_file"]);
        } else {
            $newuser_template_file = "";
        }
        
        if (isset($_POST["trusted_server"])) {
            $trusted_server = trim($_POST["trusted_server"]);
        } else {
            $trusted_server = "";
        }
        
        if (isset($_POST["trusted_port"])) {
            $trusted_port = trim($_POST["trusted_port"]);
        } else {
            $trusted_port = "";
        }

        $update = "UPDATE maia_config SET enable_user_autocreation = 'N', " .
                                         "internal_auth = 'Y', " .
                                         "admin_email = ?, " .
                                         "reminder_login_url = ?, " .
                                         "newuser_template_file = ?, " .
                                         "smtp_server = ?, " .
                                         "smtp_port = ? " . 
                                       "WHERE id = 0";
        $dbh->query($update, array($admin_email,
                                   $reminder_login_url,
                                   $newuser_template_file,
                                   $trusted_server,
                                   $trusted_port
                                   ));


        $new_email = get_rewritten_email_address($your_email, $address_rewriting_type);
        $username = $new_email;

        $new_user_id = add_user($username, $new_email);

        // Generate a random password and assign it to the new user
        list($password, $digest) = generate_random_password();
        $update = "UPDATE maia_users SET password = ? WHERE id = ?";
        $dbh->query($update, array($digest, $new_user_id));

        $fh = fopen($newuser_template_file, "r");
        if ($fh) {
          $body = fread($fh, filesize($newuser_template_file));
          fclose($fh);
          $body = preg_replace("/%%ADMINEMAIL%%/", $admin_email, $body);
          $body = preg_replace("/%%LOGIN%%/", $username, $body);
          $body = preg_replace("/%%PASSWORD%%/", $password, $body);
          $body = preg_replace("/%%LOGINURL%%/", $reminder_login_url, $body);
          $result = smtp_send($admin_email, $new_email, $body);
          if ($succeeded = (strncmp($result, "2", 1) == 0)) {
            $smarty->assign("error", $result);
          }
        } else {
          $smarty->assign("error", "Unable to open newuser.tpl template file: Please check you path and permissions."); 
        }
    } else {
        $smarty->assign("submitted", false);
        $select = "SELECT admin_email, " .
                         "reminder_login_url, " .
                         "newuser_template_file, " .
                         "smtp_server, " .
                         "smtp_port " .
                  "FROM maia_config WHERE id = 0";
        $sth = $dbh->query($select);
        if ($row = $sth->fetchrow()) {
            $admin_email = $row["admin_email"];
            $reminder_login_url = $row["reminder_login_url"];
            $newuser_template_file = $row["newuser_template_file"];
            $trusted_server = $row["smtp_server"];
            $trusted_port = $row["smtp_port"];
            
        }
       $sth->free();
} 

       $smarty->assign("newuser_template_file", $newuser_template_file);
       $smarty->assign("reminder_login_url", $reminder_login_url);
       $smarty->assign("admin_email", $admin_email);
       $smarty->assign("trusted_server", $trusted_server);
       $smarty->assign("trusted_port", $trusted_port);
       
$smarty->display("internal-init.tpl");
?>
