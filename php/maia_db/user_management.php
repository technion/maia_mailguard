<?php
    /*
     * who_am_i(): Returns a string describing the effective user, and the
     *             administrator (if the admin is impersonating a user).
     */
    function who_am_i($uid, $euid)
    {
       global $lang;

       $fake_user = get_user_name($euid);
       if ($uid != $euid) {
          $real_user = get_user_name($uid);
          if (is_a_domain_default_user($euid)) {
              if (is_system_default_user($euid)) {
                  $i_am = $lang['text_banner_system_user'];
              } else {
                  $i_am = sprintf($lang['text_banner_domain_user'], $fake_user);
              }
          } else {
              $i_am = sprintf($lang['text_banner_administrator'], $real_user, $fake_user);
          }
       } else {
          $i_am = sprintf($lang['text_banner_user'], $fake_user);
       }
       return ($i_am);
    }


    /*
     * ok_to_impersonate(): Returns true if user $uid is allowed to
     *                      impersonate user $euid, false otherwise.
     *                      Note that this is only used to determine
     *                      whether the impersonator should be allowed
     *                      to view and administer the user's mail
     *                      items.  This test is not necessary for
     *                      adjusting a user's settings.
     */
    function ok_to_impersonate($euid, $uid)
    {
        global $dbh;

      // It's harmless to impersonate yourself ;)
        if (($euid == $uid) && ($euid > 0) && ($uid > 0)) {
            return true;
        } else {

          // Domain default users can be impersonated by admins
          // responsible for those domains, and the superadmin.
          // Only the superadmin can impersonate the system default
          // user (@.).
            if (is_a_domain_default_user($euid) || get_config_value("enable_privacy_invasion") == "Y") {

              if (is_superadmin($uid)) {
                  return true;
              } else {
                if (is_a_domain_default_user($euid)) {
                  $domain_id = get_domain_id(get_user_name($euid));
                    return (is_admin_for_domain($uid, $domain_id));
                } else if (!is_superadmin($euid)) {

                    $sth = $dbh->prepare("SELECT email FROM users WHERE maia_user_id = ?");
                    $res = $sth->execute(array($euid));
                    if (PEAR::isError($sth)) {
                        die($sth->getMessage());
                    }
                    while ($row = $res->fetchRow()) {
                      $domain_id = get_domain_id("@" . get_domain_from_email($row["email"]));
                      if (is_admin_for_domain($uid, $domain_id)) {
                          $sth->free();
                          return true;
                      }
                    }
                    $sth->free();
                    return false;

                } else {
                    return false;
                }
              }
              // Impersonating other users is an invasion of privacy,
              // even for administrators, unless explicitly overridden above.
            } else {
                return false;
            }
        }
    }


    /*
     * get_user_name(): Returns the name of the specified user.  For
     *                  auto-created accounts, this will be the same
     *                  as the user's e-mail address, until the user
     *                  finally logs in.
     */
    function get_user_name($uid)
    {
        global $dbh;

        $user_name = "Unknown";
        $sth = $dbh->prepare("SELECT user_name FROM maia_users WHERE id = ?");
        $res = $sth->execute(array($uid));
        if (PEAR::isError($sth)) { 
            die($sth->getMessage()); 
	}
        if ($row = $res->fetchRow()) {
            $user_name = $row["user_name"];
        }
        $sth->free();

        return $user_name;
    }


    /*
     * get_user_id(): Looks up the Maia ID of the specified user
     *                by name. Renames database entry from $email
     *                to $user_name if $user_name is not found
     *                and $email is found.
     */
    function get_user_id($user_name, $email)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT id FROM maia_users " .
                  "WHERE user_name = ?");
        $res = $sth->execute(array($user_name));

        // Try to look the user up by name first.
        if ($row = $res->fetchRow()) {

            $uid = $row["id"];
            $sth->free();

        } else {


            // Now try looking the user up by e-mail address,
            // in case the user was "auto-created".
            $res = $sth->execute(array($email));
            if (PEAR::isError($sth)) {
                die($sth->getMessage());
            }
            if ($row = $res->fetchRow()) {
               $uid = $row["id"];
               $sth->free();

               // Set the user's proper name in the database
               // record, to speed up future lookups.
               $sth = $dbh->prepare("UPDATE maia_users SET user_name = ? " .
                         "WHERE id = ?");
               $sth->execute(array($user_name, $uid));
               if (PEAR::isError($sth)) {
                   die($sth->getMessage());
               }

            } else {

               // Not found!
               $uid = 0;

            }
        }

        $sth->free();
        return $uid;
    }


    /*
     * get_user_level(): Returns the user's privilege level,
     *                   one of:
     *
     *                   'U' : User
     *                   'A' : Domain Administrator
     *                   'S' : Superadministrator
     */
    function get_user_level($uid)
    {
        global $dbh;

        $sth = $dbh->prepare( "SELECT user_level FROM maia_users " .
                  "WHERE id = ?");
        $res = $sth->execute(array($uid));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $user_level = "U";
        if ($row = $res->fetchRow()) {
            $user_level = $row["user_level"];
        }
        $sth->free();

      return $user_level;
    }

    /*
      * add_user(): Creates a new user record, based on a new e-mail
      *             address and user name.
      */
    function add_user($user_name, $email)
    {
        global $dbh;
        global $logger;

        // get domain default if available....
        $domain = get_domain_from_email($email);
        $domain_id = get_user_id("@" . $domain, "@" . $domain);
        if ($domain_id != 0) {
            $domain_defaults = get_maia_user_row($domain_id);
        } else {
            $domain_defaults = get_maia_user_row(get_user_id("@.", "@."));
        }


        // Add an entry to the maia_users table
        $sth = $dbh->prepare("INSERT INTO maia_users (user_name, reminders, charts, language, auto_whitelist, " .
                  "items_per_page, theme_id, quarantine_digest_interval, truncate_subject, truncate_email, spamtrap) " .
                  "VALUES (?,?,?,?,?,?,?,?,?,?,'N')");
        $res = $sth->execute(array($user_name,
                                 $domain_defaults["reminders"],
                                   $domain_defaults["charts"],
                 $domain_defaults["language"],
                 $domain_defaults["auto_whitelist"],
                 $domain_defaults["items_per_page"],
                 $domain_defaults["theme_id"],
                 $domain_defaults["quarantine_digest_interval"],
                 $domain_defaults["truncate_subject"],
                 $domain_defaults["truncate_email"]));
        if (PEAR::isError($res)) {
            $logger->err("Can't insert new user: ". $res->getMessage());
            return -1;
        }
        $sth->free();
        // Get the UID of this new record
        $sth = $dbh->prepare("SELECT id FROM maia_users WHERE user_name = ?");
        $res = $sth->execute(array($user_name));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        if ($row = $res->fetchRow()) {
            $uid = $row["id"];
        }
        $sth->free();

        // Link this e-mail address to this user
        $email_id = add_email_address_to_user($uid, $email);

        // Make this e-mail address the user's primary address
        set_primary_email($uid, $email_id);

        return $uid;
     }


    /*
     * transfer_email_address_to_user(): Transfers an e-mail address
     *                                   from one user to another.
     */
    function transfer_email_address_to_user($old_owner_id, $new_owner_id, $email)
    {
        global $dbh;

        // Link the e-mail address to the new owner
        $sth = $dbh->prepare("UPDATE users SET maia_user_id = ? WHERE email = ?");
        $sth->execute(array($new_owner_id, $email));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $sth->free();

        // If the old owner has no other e-mail addresses, merge
        // the old owner's assets into the new owner's account
        // and delete the old owner.
        $sth = $dbh->prepare("SELECT id FROM users WHERE maia_user_id = ?");
        $res = $sth->execute(array($old_owner_id));
        if (!$res->fetchRow()) {
            transfer_mail_to_user($old_owner_id, $new_owner_id);
            transfer_wblist_to_user($old_owner_id, $new_owner_id);
            transfer_domain_admin_to_user($old_owner_id, $new_owner_id);
            transfer_stats_to_user($old_owner_id, $new_owner_id);
               update_mail_stats($new_owner_id, "suspected_ham");
               update_mail_stats($new_owner_id, "suspected_spam");
            delete_user($old_owner_id);
        }
        $sth->free();
    }


    /*
     * transfer_stats_to_user(): Merges one user's mail statistics
     *                           into another's.
     */
    function transfer_stats_to_user($old_owner_id, $new_owner_id)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT oldest_ham_date, " .
                         "newest_ham_date, " .
                         "smallest_ham_size, " .
                         "largest_ham_size, " .
                         "total_ham_size, " .
                         "lowest_ham_score, " .
                         "highest_ham_score, " .
                         "total_ham_score, " .
                         "total_ham_items, " .
                         "oldest_wl_date, " .
                         "newest_wl_date, " .
                         "smallest_wl_size, " .
                         "largest_wl_size, " .
                         "total_wl_size, " .
                         "total_wl_items, " .
                         "oldest_bl_date, " .
                         "newest_bl_date, " .
                         "smallest_bl_size, " .
                         "largest_bl_size, " .
                         "total_bl_size, " .
                         "total_bl_items, " .
                         "oldest_fp_date, " .
                         "newest_fp_date, " .
                         "smallest_fp_size, " .
                         "largest_fp_size, " .
                         "total_fp_size, " .
                         "lowest_fp_score, " .
                         "highest_fp_score, " .
                         "total_fp_score, " .
                         "total_fp_items, " .
                         "oldest_fn_date, " .
                         "newest_fn_date, " .
                         "smallest_fn_size, " .
                         "largest_fn_size, " .
                         "total_fn_size, " .
                         "lowest_fn_score, " .
                         "highest_fn_score, " .
                         "total_fn_score, " .
                         "total_fn_items, " .
                         "oldest_spam_date, " .
                         "newest_spam_date, " .
                         "smallest_spam_size, " .
                         "largest_spam_size, " .
                         "total_spam_size, " .
                         "lowest_spam_score, " .
                         "highest_spam_score, " .
                         "total_spam_score, " .
                         "total_spam_items, " .
                         "oldest_virus_date, " .
                         "newest_virus_date, " .
                         "smallest_virus_size, " .
                         "largest_virus_size, " .
                         "total_virus_size, " .
                         "total_virus_items, " .
                         "oldest_bad_header_date, " .
                         "newest_bad_header_date, " .
                         "smallest_bad_header_size, " .
                         "largest_bad_header_size, " .
                         "total_bad_header_size, " .
                         "total_bad_header_items, " .
                         "oldest_banned_file_date, " .
                         "newest_banned_file_date, " .
                         "smallest_banned_file_size, " .
                         "largest_banned_file_size, " .
                         "total_banned_file_size, " .
                         "total_banned_file_items, " .
                         "oldest_oversized_date, " .
                         "newest_oversized_date, " .
                         "smallest_oversized_size, " .
                         "largest_oversized_size, " .
                         "total_oversized_size, " .
                         "total_oversized_items " .
                  "FROM maia_stats WHERE user_id = ?");
        $res = $sth->execute(array($old_owner_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        if ($row = $res->fetchRow()) {
            $old_oldest_ham_date = $row["oldest_ham_date"];
            $old_newest_ham_date = $row["newest_ham_date"];
            $old_smallest_ham_size = $row["smallest_ham_size"];
            $old_largest_ham_size = $row["largest_ham_size"];
            $old_total_ham_size = $row["total_ham_size"];
            $old_lowest_ham_score = $row["lowest_ham_score"];
            $old_highest_ham_score = $row["highest_ham_score"];
            $old_total_ham_score = $row["total_ham_score"];
            $old_total_ham_items = $row["total_ham_items"];
            $old_oldest_wl_date = $row["oldest_wl_date"];
            $old_newest_wl_date = $row["newest_wl_date"];
            $old_smallest_wl_size = $row["smallest_wl_size"];
            $old_largest_wl_size = $row["largest_wl_size"];
            $old_total_wl_size = $row["total_wl_size"];
            $old_total_wl_items = $row["total_wl_items"];
            $old_oldest_bl_date = $row["oldest_bl_date"];
            $old_newest_bl_date = $row["newest_bl_date"];
            $old_smallest_bl_size = $row["smallest_bl_size"];
            $old_largest_bl_size = $row["largest_bl_size"];
            $old_total_bl_size = $row["total_bl_size"];
            $old_total_bl_items = $row["total_bl_items"];
            $old_oldest_fp_date = $row["oldest_fp_date"];
            $old_newest_fp_date = $row["newest_fp_date"];
            $old_smallest_fp_size = $row["smallest_fp_size"];
            $old_largest_fp_size = $row["largest_fp_size"];
            $old_total_fp_size = $row["total_fp_size"];
            $old_lowest_fp_score = $row["lowest_fp_score"];
            $old_highest_fp_score = $row["highest_fp_score"];
            $old_total_fp_score = $row["total_fp_score"];
            $old_total_fp_items = $row["total_fp_items"];
            $old_oldest_fn_date = $row["oldest_fn_date"];
            $old_newest_fn_date = $row["newest_fn_date"];
            $old_smallest_fn_size = $row["smallest_fn_size"];
            $old_largest_fn_size = $row["largest_fn_size"];
            $old_total_fn_size = $row["total_fn_size"];
            $old_lowest_fn_score = $row["lowest_fn_score"];
            $old_highest_fn_score = $row["highest_fn_score"];
            $old_total_fn_score = $row["total_fn_score"];
            $old_total_fn_items = $row["total_fn_items"];
            $old_oldest_spam_date = $row["oldest_spam_date"];
            $old_newest_spam_date = $row["newest_spam_date"];
            $old_smallest_spam_size = $row["smallest_spam_size"];
            $old_largest_spam_size = $row["largest_spam_size"];
            $old_total_spam_size = $row["total_spam_size"];
            $old_lowest_spam_score = $row["lowest_spam_score"];
            $old_highest_spam_score = $row["highest_spam_score"];
            $old_total_spam_score = $row["total_spam_score"];
            $old_total_spam_items = $row["total_spam_items"];
            $old_oldest_virus_date = $row["oldest_virus_date"];
            $old_newest_virus_date = $row["newest_virus_date"];
            $old_smallest_virus_size = $row["smallest_virus_size"];
            $old_largest_virus_size = $row["largest_virus_size"];
            $old_total_virus_size = $row["total_virus_size"];
            $old_total_virus_items = $row["total_virus_items"];
            $old_oldest_bad_header_date = $row["oldest_bad_header_date"];
            $old_newest_bad_header_date = $row["newest_bad_header_date"];
            $old_smallest_bad_header_size = $row["smallest_bad_header_size"];
            $old_largest_bad_header_size = $row["largest_bad_header_size"];
            $old_total_bad_header_size = $row["total_bad_header_size"];
            $old_total_bad_header_items = $row["total_bad_header_items"];
            $old_oldest_banned_file_date = $row["oldest_banned_file_date"];
            $old_newest_banned_file_date = $row["newest_banned_file_date"];
            $old_smallest_banned_file_size = $row["smallest_banned_file_size"];
            $old_largest_banned_file_size = $row["largest_banned_file_size"];
            $old_total_banned_file_size = $row["total_banned_file_size"];
            $old_total_banned_file_items = $row["total_banned_file_items"];
            $old_oldest_oversized_date = $row["oldest_oversized_date"];
            $old_newest_oversized_date = $row["newest_oversized_date"];
            $old_smallest_oversized_size = $row["smallest_oversized_size"];
            $old_largest_oversized_size = $row["largest_oversized_size"];
            $old_total_oversized_size = $row["total_oversized_size"];
            $old_total_oversized_items = $row["total_oversized_items"];

            // New owner already has a stats record, merge the old owner's
            // stats into this record appropriately.
            $res2 = $sth->execute(array($new_owner_id));
            if (PEAR::isError($sth)) {
                die($sth->getMessage());
            } 
            if ($row2 = $res2->fetchRow()) {

             // Confirmed Ham
                $new_oldest_ham_date = $row2["oldest_ham_date"];
                if ($old_oldest_ham_date != NULL && $old_oldest_ham_date < $new_oldest_ham_date) {
                    $new_oldest_ham_date = $old_oldest_ham_date;
                }
                $new_newest_ham_date = $row2["newest_ham_date"];
                if ($old_newest_ham_date > $new_newest_ham_date) {
                    $new_newest_ham_date = $old_newest_ham_date;
                }
                $new_smallest_ham_size = $row2["smallest_ham_size"];
                if ($old_smallest_ham_size < $new_smallest_ham_size) {
                    $new_smallest_ham_size = $old_smallest_ham_size;
                }
                $new_largest_ham_size = $row2["largest_ham_size"];
                if ($old_largest_ham_size > $new_largest_ham_size) {
                    $new_largest_ham_size = $old_largest_ham_size;
                }
                $new_total_ham_size = $row2["total_ham_size"] + $old_total_ham_size;
                $new_lowest_ham_score = $row2["lowest_ham_score"];
                if ($old_lowest_ham_score < $new_lowest_ham_score) {
                    $new_lowest_ham_score = $old_lowest_ham_score;
                }
                $new_highest_ham_score = $row2["highest_ham_score"];
                if ($old_highest_ham_score > $new_highest_ham_score) {
                    $new_highest_ham_score = $old_highest_ham_score;
                }
                $new_total_ham_score = $row2["total_ham_score"] + $old_total_ham_score;
                $new_total_ham_items = $row2["total_ham_items"] + $old_total_ham_items;

                // Whitelisted Sender
                $new_oldest_wl_date = $row2["oldest_wl_date"];
                if ($old_oldest_wl_date != NULL && $old_oldest_wl_date < $new_oldest_wl_date) {
                    $new_oldest_wl_date = $old_oldest_wl_date;
                }
                $new_newest_wl_date = $row2["newest_wl_date"];
                if ($old_newest_wl_date > $new_newest_wl_date) {
                    $new_newest_wl_date = $old_newest_wl_date;
                }
                $new_smallest_wl_size = $row2["smallest_wl_size"];
                if ($old_smallest_wl_size < $new_smallest_wl_size) {
                    $new_smallest_wl_size = $old_smallest_wl_size;
                }
                $new_largest_wl_size = $row2["largest_wl_size"];
                if ($old_largest_wl_size > $new_largest_wl_size) {
                    $new_largest_wl_size = $old_largest_wl_size;
                }
                $new_total_wl_size = $row2["total_wl_size"] + $old_total_wl_size;
                $new_total_wl_items = $row2["total_wl_items"] + $old_total_wl_items;

                // Blacklisted Sender
                $new_oldest_bl_date = $row2["oldest_bl_date"];
                if ($old_oldest_bl_date != NULL && $old_oldest_bl_date < $new_oldest_bl_date) {
                    $new_oldest_bl_date = $old_oldest_bl_date;
                }
                $new_newest_bl_date = $row2["newest_bl_date"];
                if ($old_newest_bl_date > $new_newest_bl_date) {
                    $new_newest_bl_date = $old_newest_bl_date;
                }
                $new_smallest_bl_size = $row2["smallest_bl_size"];
                if ($old_smallest_bl_size < $new_smallest_bl_size) {
                    $new_smallest_bl_size = $old_smallest_bl_size;
                }
                $new_largest_bl_size = $row2["largest_bl_size"];
                if ($old_largest_bl_size > $new_largest_bl_size) {
                    $new_largest_bl_size = $old_largest_bl_size;
                }
                $new_total_bl_size = $row2["total_bl_size"] + $old_total_bl_size;
                $new_total_bl_items = $row2["total_bl_items"] + $old_total_bl_items;

                // False Positives
                $new_oldest_fp_date = $row2["oldest_fp_date"];
                if ($old_oldest_fp_date != NULL && $old_oldest_fp_date < $new_oldest_fp_date) {
                    $new_oldest_fp_date = $old_oldest_fp_date;
                }
                $new_newest_fp_date = $row2["newest_fp_date"];
                if ($old_newest_fp_date > $new_newest_fp_date) {
                    $new_newest_fp_date = $old_newest_fp_date;
                }
                $new_smallest_fp_size = $row2["smallest_fp_size"];
                if ($old_smallest_fp_size < $new_smallest_fp_size) {
                    $new_smallest_fp_size = $old_smallest_fp_size;
                }
                $new_largest_fp_size = $row2["largest_fp_size"];
                if ($old_largest_fp_size > $new_largest_fp_size) {
                    $new_largest_fp_size = $old_largest_fp_size;
                }
                $new_total_fp_size = $row2["total_fp_size"] + $old_total_fp_size;
                $new_lowest_fp_score = $row2["lowest_fp_score"];
                if ($old_lowest_fp_score < $new_lowest_fp_score) {
                    $new_lowest_fp_score = $old_lowest_fp_score;
                }
                $new_highest_fp_score = $row2["highest_fp_score"];
                if ($old_highest_fp_score > $new_highest_fp_score) {
                    $new_highest_fp_score = $old_highest_fp_score;
                }
                $new_total_fp_score = $row2["total_fp_score"] + $old_total_fp_score;
                $new_total_fp_items = $row2["total_fp_items"] + $old_total_fp_items;

                // False Negatives
                $new_oldest_fn_date = $row2["oldest_fn_date"];
                if ($old_oldest_fn_date != NULL && $old_oldest_fn_date < $new_oldest_fn_date) {
                    $new_oldest_fn_date = $old_oldest_fn_date;
                }
                $new_newest_fn_date = $row2["newest_fn_date"];
                if ($old_newest_fn_date > $new_newest_fn_date) {
                    $new_newest_fn_date = $old_newest_fn_date;
                }
                $new_smallest_fn_size = $row2["smallest_fn_size"];
                if ($old_smallest_fn_size < $new_smallest_fn_size) {
                    $new_smallest_fn_size = $old_smallest_fn_size;
                }
                $new_largest_fn_size = $row2["largest_fn_size"];
                if ($old_largest_fn_size > $new_largest_fn_size) {
                    $new_largest_fn_size = $old_largest_fn_size;
                }
                $new_total_fn_size = $row2["total_fn_size"] + $old_total_fn_size;
                $new_lowest_fn_score = $row2["lowest_fn_score"];
                if ($old_lowest_fn_score < $new_lowest_fn_score) {
                    $new_lowest_fn_score = $old_lowest_fn_score;
                }
                $new_highest_fn_score = $row2["highest_fn_score"];
                if ($old_highest_fn_score > $new_highest_fn_score) {
                    $new_highest_fn_score = $old_highest_fn_score;
                }
                $new_total_fn_score = $row2["total_fn_score"] + $old_total_fn_score;
                $new_total_fn_items = $row2["total_fn_items"] + $old_total_fn_items;

                // Confirmed Spam
                $new_oldest_spam_date = $row2["oldest_spam_date"];
                if ($old_oldest_spam_date != NULL && $old_oldest_spam_date < $new_oldest_spam_date) {
                    $new_oldest_spam_date = $old_oldest_spam_date;
                }
                $new_newest_spam_date = $row2["newest_spam_date"];
                if ($old_newest_spam_date > $new_newest_spam_date) {
                    $new_newest_spam_date = $old_newest_spam_date;
                }
                $new_smallest_spam_size = $row2["smallest_spam_size"];
                if ($old_smallest_spam_size < $new_smallest_spam_size) {
                    $new_smallest_spam_size = $old_smallest_spam_size;
                }
                $new_largest_spam_size = $row2["largest_spam_size"];
                if ($old_largest_spam_size > $new_largest_spam_size) {
                    $new_largest_spam_size = $old_largest_spam_size;
                }
                $new_total_spam_size = $row2["total_spam_size"] + $old_total_spam_size;
                $new_lowest_spam_score = $row2["lowest_spam_score"];
                if ($old_lowest_spam_score < $new_lowest_spam_score) {
                    $new_lowest_spam_score = $old_lowest_spam_score;
                }
                $new_highest_spam_score = $row2["highest_spam_score"];
                if ($old_highest_spam_score > $new_highest_spam_score) {
                    $new_highest_spam_score = $old_highest_spam_score;
                }
                $new_total_spam_score = $row2["total_spam_score"] + $old_total_spam_score;
                $new_total_spam_items = $row2["total_spam_items"] + $old_total_spam_items;

                // Viruses
                $new_oldest_virus_date = $row2["oldest_virus_date"];
                if ($old_oldest_virus_date != NULL && $old_oldest_virus_date < $new_oldest_virus_date) {
                    $new_oldest_virus_date = $old_oldest_virus_date;
                }
                $new_newest_virus_date = $row2["newest_virus_date"];
                if ($old_newest_virus_date > $new_newest_virus_date) {
                    $new_newest_virus_date = $old_newest_virus_date;
                }
                $new_smallest_virus_size = $row2["smallest_virus_size"];
                if ($old_smallest_virus_size < $new_smallest_virus_size) {
                    $new_smallest_virus_size = $old_smallest_virus_size;
                }
                $new_largest_virus_size = $row2["largest_virus_size"];
                if ($old_largest_virus_size > $new_largest_virus_size) {
                    $new_largest_virus_size = $old_largest_virus_size;
                }
                $new_total_virus_size = $row2["total_virus_size"] + $old_total_virus_size;
                $new_total_virus_items = $row2["total_virus_items"] + $old_total_virus_items;

                // Bad Headers
                $new_oldest_bad_header_date = $row2["oldest_bad_header_date"];
                if ($old_oldest_bad_header_date != NULL && $old_oldest_bad_header_date < $new_oldest_bad_header_date) {
                    $new_oldest_bad_header_date = $old_oldest_bad_header_date;
                }
                $new_newest_bad_header_date = $row2["newest_bad_header_date"];
                if ($old_newest_bad_header_date > $new_newest_bad_header_date) {
                    $new_newest_bad_header_date = $old_newest_bad_header_date;
                }
                $new_smallest_bad_header_size = $row2["smallest_bad_header_size"];
                if ($old_smallest_bad_header_size < $new_smallest_bad_header_size) {
                    $new_smallest_bad_header_size = $old_smallest_bad_header_size;
                }
                $new_largest_bad_header_size = $row2["largest_bad_header_size"];
                if ($old_largest_bad_header_size > $new_largest_bad_header_size) {
                    $new_largest_bad_header_size = $old_largest_bad_header_size;
                }
                $new_total_bad_header_size = $row2["total_bad_header_size"] + $old_total_bad_header_size;
                $new_total_bad_header_items = $row2["total_bad_header_items"] + $old_total_bad_header_items;

                // Banned Files
                $new_oldest_banned_file_date = $row2["oldest_banned_file_date"];
                if ($old_oldest_banned_file_date != NULL && $old_oldest_banned_file_date < $new_oldest_banned_file_date) {
                    $new_oldest_banned_file_date = $old_oldest_banned_file_date;
                }
                $new_newest_banned_file_date = $row2["newest_banned_file_date"];
                if ($old_newest_banned_file_date > $new_newest_banned_file_date) {
                    $new_newest_banned_file_date = $old_newest_banned_file_date;
                }
                $new_smallest_banned_file_size = $row2["smallest_banned_file_size"];
                if ($old_smallest_banned_file_size < $new_smallest_banned_file_size) {
                    $new_smallest_banned_file_size = $old_smallest_banned_file_size;
                }
                $new_largest_banned_file_size = $row2["largest_banned_file_size"];
                if ($old_largest_banned_file_size > $new_largest_banned_file_size) {
                    $new_largest_banned_file_size = $old_largest_banned_file_size;
                }
                $new_total_banned_file_size = $row2["total_banned_file_size"] + $old_total_banned_file_size;
                $new_total_banned_file_items = $row2["total_banned_file_items"] + $old_total_banned_file_items;

                // Oversized Items
                $new_oldest_oversized_date = $row2["oldest_oversized_date"];
                if ($old_oldest_oversized_date != NULL && $old_oldest_oversized_date < $new_oldest_oversized_date) {
                    $new_oldest_oversized_date = $old_oldest_oversized_date;
                }
                $new_newest_oversized_date = $row2["newest_oversized_date"];
                if ($old_newest_oversized_date > $new_newest_oversized_date) {
                    $new_newest_oversized_date = $old_newest_oversized_date;
                }
                $new_smallest_oversized_size = $row2["smallest_oversized_size"];
                if ($old_smallest_oversized_size < $new_smallest_oversized_size) {
                    $new_smallest_oversized_size = $old_smallest_oversized_size;
                }
                $new_largest_oversized_size = $row2["largest_oversized_size"];
                if ($old_largest_oversized_size > $new_largest_oversized_size) {
                    $new_largest_oversized_size = $old_largest_oversized_size;
                }
                $new_total_oversized_size = $row2["total_oversized_size"] + $old_total_oversized_size;
                $new_total_oversized_items = $row2["total_oversized_items"] + $old_total_oversized_items;

                $sthu = $dbh->prepare("UPDATE maia_stats SET oldest_ham_date = ?, " .
                                                "newest_ham_date = ?, " .
                                                "smallest_ham_size = ?, " .
                                                "largest_ham_size = ?, " .
                                                "total_ham_size = ?, " .
                                                "lowest_ham_score = ?, " .
                                                "highest_ham_score = ?, " .
                                                "total_ham_score = ?, " .
                                                "total_ham_items = ?, " .
                                                "oldest_wl_date = ?, " .
                                                "newest_wl_date = ?, " .
                                                "smallest_wl_size = ?, " .
                                                "largest_wl_size = ?, " .
                                                "total_wl_size = ?, " .
                                                "total_wl_items = ?, " .
                                                "oldest_bl_date = ?, " .
                                                "newest_bl_date = ?, " .
                                                "smallest_bl_size = ?, " .
                                                "largest_bl_size = ?, " .
                                                "total_bl_size = ?, " .
                                                "total_bl_items = ?, " .
                                                "oldest_fp_date = ?, " .
                                                "newest_fp_date = ?, " .
                                                "smallest_fp_size = ?, " .
                                                "largest_fp_size = ?, " .
                                                "total_fp_size = ?, " .
                                                "lowest_fp_score = ?, " .
                                                "highest_fp_score = ?, " .
                                                "total_fp_score = ?, " .
                                                "total_fp_items = ?, " .
                                                "oldest_fn_date = ?, " .
                                                "newest_fn_date = ?, " .
                                                "smallest_fn_size = ?, " .
                                                "largest_fn_size = ?, " .
                                                "total_fn_size = ?, " .
                                                "lowest_fn_score = ?, " .
                                                "highest_fn_score = ?, " .
                                                "total_fn_score = ?, " .
                                                "total_fn_items = ?, " .
                                                "oldest_spam_date = ?, " .
                                                "newest_spam_date = ?, " .
                                                "smallest_spam_size = ?, " .
                                                "largest_spam_size = ?, " .
                                                "total_spam_size = ?, " .
                                                "lowest_spam_score = ?, " .
                                                "highest_spam_score = ?, " .
                                                "total_spam_score = ?, " .
                                                "total_spam_items = ?, " .
                                                "oldest_virus_date = ?, " .
                                                "newest_virus_date = ?, " .
                                                "smallest_virus_size = ?, " .
                                                "largest_virus_size = ?, " .
                                                "total_virus_size = ?, " .
                                                "total_virus_items = ?, " .
                                                "oldest_bad_header_date = ?, " .
                                                "newest_bad_header_date = ?, " .
                                                "smallest_bad_header_size = ?, " .
                                                "largest_bad_header_size = ?, " .
                                                "total_bad_header_size = ?, " .
                                                "total_bad_header_items = ?, " .
                                                "oldest_banned_file_date = ?, " .
                                                "newest_banned_file_date = ?, " .
                                                "smallest_banned_file_size = ?, " .
                                                "largest_banned_file_size = ?, " .
                                                "total_banned_file_size = ?, " .
                                                "total_banned_file_items = ?, " .
                                                "oldest_oversized_date = ?, " .
                                                "newest_oversized_date = ?, " .
                                                "smallest_oversized_size = ?, " .
                                                "largest_oversized_size = ?, " .
                                                "total_oversized_size = ?, " .
                                                "total_oversized_items = ? " .
                          "WHERE user_id = ?");
                $sthu->execute(array($new_oldest_ham_date,
                                           $new_newest_ham_date,
                                           $new_smallest_ham_size,
                                           $new_largest_ham_size,
                                           $new_total_ham_size,
                                           $new_lowest_ham_score,
                                           $new_highest_ham_score,
                                           $new_total_ham_score,
                                           $new_total_ham_items,
                                           $new_oldest_wl_date,
                                           $new_newest_wl_date,
                                           $new_smallest_wl_size,
                                           $new_largest_wl_size,
                                           $new_total_wl_size,
                                           $new_total_wl_items,
                                           $new_oldest_bl_date,
                                           $new_newest_bl_date,
                                           $new_smallest_bl_size,
                                           $new_largest_bl_size,
                                           $new_total_bl_size,
                                           $new_total_bl_items,
                                           $new_oldest_fp_date,
                                           $new_newest_fp_date,
                                           $new_smallest_fp_size,
                                           $new_largest_fp_size,
                                           $new_total_fp_size,
                                           $new_lowest_fp_score,
                                           $new_highest_fp_score,
                                           $new_total_fp_score,
                                           $new_total_fp_items,
                                           $new_oldest_fn_date,
                                           $new_newest_fn_date,
                                           $new_smallest_fn_size,
                                           $new_largest_fn_size,
                                           $new_total_fn_size,
                                           $new_lowest_fn_score,
                                           $new_highest_fn_score,
                                           $new_total_fn_score,
                                           $new_total_fn_items,
                                           $new_oldest_spam_date,
                                           $new_newest_spam_date,
                                           $new_smallest_spam_size,
                                           $new_largest_spam_size,
                                           $new_total_spam_size,
                                           $new_lowest_spam_score,
                                           $new_highest_spam_score,
                                           $new_total_spam_score,
                                           $new_total_spam_items,
                                           $new_oldest_virus_date,
                                           $new_newest_virus_date,
                                           $new_smallest_virus_size,
                                           $new_largest_virus_size,
                                           $new_total_virus_size,
                                           $new_total_virus_items,
                                           $new_oldest_bad_header_date,
                                           $new_newest_bad_header_date,
                                           $new_smallest_bad_header_size,
                                           $new_largest_bad_header_size,
                                           $new_total_bad_header_size,
                                           $new_total_bad_header_items,
                                           $new_oldest_banned_file_date,
                                           $new_newest_banned_file_date,
                                           $new_smallest_banned_file_size,
                                           $new_largest_banned_file_size,
                                           $new_total_banned_file_size,
                                           $new_total_banned_file_items,
                                           $new_oldest_oversized_date,
                                           $new_newest_oversized_date,
                                           $new_smallest_oversized_size,
                                           $new_largest_oversized_size,
                                           $new_total_oversized_size,
                                           $new_total_oversized_items,
                                           $new_owner_id));
            if (PEAR::isError($sthu)) {
                die($sthu->getMessage());
            }

            // New owner does NOT have a stats record yet, so just
            // copy the old owner's stats over directly.
            } else {

                $sthi = $dbh->prepare("INSERT INTO maia_stats (oldest_ham_date, " .
                                                  "newest_ham_date, " .
                                                  "smallest_ham_size, " .
                                                  "largest_ham_size, " .
                                                  "total_ham_size, " .
                                                  "lowest_ham_score, " .
                                                  "highest_ham_score, " .
                                                  "total_ham_score, " .
                                                  "total_ham_items, " .
                                                  "oldest_wl_date, " .
                                                  "newest_wl_date, " .
                                                  "smallest_wl_size, " .
                                                  "largest_wl_size, " .
                                                  "total_wl_size, " .
                                                  "total_wl_items, " .
                                                  "oldest_bl_date, " .
                                                  "newest_bl_date, " .
                                                  "smallest_bl_size, " .
                                                  "largest_bl_size, " .
                                                  "total_bl_size, " .
                                                  "total_bl_items, " .
                                                  "oldest_fp_date, " .
                                                  "newest_fp_date, " .
                                                  "smallest_fp_size, " .
                                                  "largest_fp_size, " .
                                                  "total_fp_size, " .
                                                  "lowest_fp_score, " .
                                                  "highest_fp_score, " .
                                                  "total_fp_score, " .
                                                  "total_fp_items, " .
                                                  "oldest_fn_date, " .
                                                  "newest_fn_date, " .
                                                  "smallest_fn_size, " .
                                                  "largest_fn_size, " .
                                                  "total_fn_size, " .
                                                  "lowest_fn_score, " .
                                                  "highest_fn_score, " .
                                                  "total_fn_score, " .
                                                  "total_fn_items, " .
                                                  "oldest_spam_date, " .
                                                  "newest_spam_date, " .
                                                  "smallest_spam_size, " .
                                                  "largest_spam_size, " .
                                                  "total_spam_size, " .
                                                  "lowest_spam_score, " .
                                                  "highest_spam_score, " .
                                                  "total_spam_score, " .
                                                  "total_spam_items, " .
                                                  "oldest_virus_date, " .
                                                  "newest_virus_date, " .
                                                  "smallest_virus_size, " .
                                                  "largest_virus_size, " .
                                                  "total_virus_size, " .
                                                  "total_virus_items, " .
                                                  "oldest_bad_header_date, " .
                                                  "newest_bad_header_date, " .
                                                  "smallest_bad_header_size, " .
                                                  "largest_bad_header_size, " .
                                                  "total_bad_header_size, " .
                                                  "total_bad_header_items, " .
                                                  "oldest_banned_file_date, " .
                                                  "newest_banned_file_date, " .
                                                  "smallest_banned_file_size, " .
                                                  "largest_banned_file_size, " .
                                                  "total_banned_file_size, " .
                                                  "total_banned_file_items, " .
                                                  "oldest_oversized_date, " .
                                                  "newest_oversized_date, " .
                                                  "smallest_oversized_size, " .
                                                  "largest_oversized_size, " .
                                                  "total_oversized_size, " .
                                                  "total_oversized_items, " .
                                                  "user_id) " .
                          "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?," .
                                  "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?," .
                                  "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?," .
                                  "?,?,?,?,?,?,?,?,?,?,?,?,?)");
                $sti->execute(array($old_oldest_ham_date,
                                           $old_newest_ham_date,
                                           $old_smallest_ham_size,
                                           $old_largest_ham_size,
                                           $old_total_ham_size,
                                           $old_lowest_ham_score,
                                           $old_highest_ham_score,
                                           $old_total_ham_score,
                                           $old_total_ham_items,
                                           $old_oldest_wl_date,
                                           $old_newest_wl_date,
                                           $old_smallest_wl_size,
                                           $old_largest_wl_size,
                                           $old_total_wl_size,
                                           $old_total_wl_items,
                                           $old_oldest_bl_date,
                                           $old_newest_bl_date,
                                           $old_smallest_bl_size,
                                           $old_largest_bl_size,
                                           $old_total_bl_size,
                                           $old_total_bl_items,
                                           $old_oldest_fp_date,
                                           $old_newest_fp_date,
                                           $old_smallest_fp_size,
                                           $old_largest_fp_size,
                                           $old_total_fp_size,
                                           $old_lowest_fp_score,
                                           $old_highest_fp_score,
                                           $old_total_fp_score,
                                           $old_total_fp_items,
                                           $old_oldest_fn_date,
                                           $old_newest_fn_date,
                                           $old_smallest_fn_size,
                                           $old_largest_fn_size,
                                           $old_total_fn_size,
                                           $old_lowest_fn_score,
                                           $old_highest_fn_score,
                                           $old_total_fn_score,
                                           $old_total_fn_items,
                                           $old_oldest_spam_date,
                                           $old_newest_spam_date,
                                           $old_smallest_spam_size,
                                           $old_largest_spam_size,
                                           $old_total_spam_size,
                                           $old_lowest_spam_score,
                                           $old_highest_spam_score,
                                           $old_total_spam_score,
                                           $old_total_spam_items,
                                           $old_oldest_virus_date,
                                           $old_newest_virus_date,
                                           $old_smallest_virus_size,
                                           $old_largest_virus_size,
                                           $old_total_virus_size,
                                           $old_total_virus_items,
                                           $old_oldest_bad_header_date,
                                           $old_newest_bad_header_date,
                                           $old_smallest_bad_header_size,
                                           $old_largest_bad_header_size,
                                           $old_total_bad_header_size,
                                           $old_total_bad_header_items,
                                           $old_oldest_banned_file_date,
                                           $old_newest_banned_file_date,
                                           $old_smallest_banned_file_size,
                                           $old_largest_banned_file_size,
                                           $old_total_banned_file_size,
                                           $old_total_banned_file_items,
                                           $old_oldest_oversized_date,
                                           $old_newest_oversized_date,
                                           $old_smallest_oversized_size,
                                           $old_largest_oversized_size,
                                           $old_total_oversized_size,
                                           $old_total_oversized_items,
                                           $new_owner_id));
                 if (PEAR::isError($sth)) {
                    die($sth->getMessage());
                $sti->free();
                }
                  
            }
            $sth2->free();
        }
        $sth->free();
    }


    /*
     * transfer_domain_admin_to_user(): Transfer domain administration
     *                                  privileges from one user to another.
     */
    function transfer_domain_admin_to_user($old_owner_id, $new_owner_id)
    {
        global $dbh;
    
        $sth = $dbh->prepare("UPDATE maia_domain_admins SET admin_id = ? WHERE admin_id = ?");
        $sth->execute(array($new_owner_id, $old_owner_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $sth->free();
    }


    /*
    * transfer_wblist_to_user(): Merge one user's whitelist and blacklist
    *                            into another's.
    */
    function transfer_wblist_to_user($old_owner_id, $new_owner_id)
    {
        global $dbh;

        $sth = $dbh->prepare("UPDATE wblist SET rid = ? WHERE rid = ?");
        $sth->execute(array($new_owner_id, $old_owner_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
    }


    /*
    * transfer_mail_to_user(): Transfer one user's e-mail assets (quarantine
    *                          and ham cache) to another.
    */
    function transfer_mail_to_user($old_owner_id, $new_owner_id)
    {
        global $dbh;

        $sth = $dbh->prepare("UPDATE maia_mail_recipients SET recipient_id = ? WHERE recipient_id = ?");
        $sth->execute(array($new_owner_id, $old_owner_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
    }


    /*
    * delete_user(): Deletes a user and all of his assets.
    */
    function delete_user($uid)
    {
        global $dbh;

        // Delete any e-mail addresses this user owns
        delete_user_email_addresses($uid);

        // Delete the user's statistics
        $sth = $dbh->prepare("DELETE FROM maia_stats WHERE user_id = ?");
        $sth->execute(array($uid));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $sth->free();

        // Delete the user's white/blacklist entries
        delete_user_wb_entries($uid);

        // Delete the user's domain admin records
        $sth = $dbh->prepare("DELETE FROM maia_domain_admins WHERE admin_id = ?");
        $sth->execute(array($uid));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $sth->free();

        // Delete the user's mail references
        delete_user_mail_references($uid);

        // Delete the user's record itself
        $sth = $dbh->prepare("DELETE FROM maia_users WHERE id = ?");
        $sth->execute(array($uid));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
    }

    /*
    * is_system_default_user(): Returns true if the given user
    *                           is the system's pseudo-user.
    */
    function is_system_default_user($uid)
    {
        return (get_user_name($uid) == "@.");
    }


    /*
    * is_a_domain_default_user(): Returns true if the given user
    *                             is a domain-class pseudo-user.
    */
    function is_a_domain_default_user($uid)
    {
        $user_name = get_user_name($uid);
        return ($user_name[0] == "@");
    }

    /*
    * add_address_to_user(): Add a address to the users table
    *
    */
    function add_address_to_user($policy_id, $address, $uid, $domain_id)
    {
        global $dbh;
        $priority = get_email_address_priority($address);
        $sth = $dbh->prepare("INSERT INTO users (policy_id, email, priority, maia_user_id, maia_domain_id) VALUES (?,?,?,?,?)");
        $sth->execute(array($policy_id, $address, $priority, $uid, $domain_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $sth->free();
        $sth = $dbh->prepare("SELECT id FROM users WHERE email = ?");
        $res = $sth->execute(array($address));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        if ($row = $res->fetchrow()) {
           $email_id = $row["id"];
        } else {
         $email_id = 0;
        }
        $sth->free();
        return $email_id;
    }


    /*
    * add_email_address_to_user(): Links a new e-mail address to the
    *                              specified user's account.
    */
    function add_email_address_to_user($uid, $email)
    {
        global $dbh;

        // Add a new policy for this user
        $policy_id = add_policy($email);

        // Add the user's e-mail address to the amavisd users table
        $new_address_id = add_address_to_user($policy_id, $email, $uid, 0);
        return $new_address_id;
    }


    /*
    * get_primary_email_id(): Returns the ID of the specified user's
    *                         primary e-mail address.
    */
    function get_primary_email_id($user_id)
    {
        global $dbh;

        $email_id = 0;
        $sth = $dbh->prepare("SELECT primary_email_id FROM maia_users WHERE id = ?");
        $res = $sth->execute(array($user_id));
        if ($row = $res->fetchrow()) {
           $email_id = $row["primary_email_id"];
        }
        $sth->free();

        return $email_id;
    }


    /*
    * set_primary_email(): Registers the specified e-mail address
    *                      as the specified user's primary address.
    */
    function set_primary_email($user_id, $email_id)
    {
        global $dbh;

        $sth = $dbh->prepare("UPDATE maia_users SET primary_email_id = ? WHERE id = ?");
        $sth->execute(array($email_id, $user_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
    }



    /*
    * get_display_language(): Determine which language to use for
    *                         HTML display purposes.  User-specified
    *                         choices are preferred, but the default
    *                         language (specified in config.php) will
    *                         be used if no other language is
    *                         specified.
    */
    function get_display_language($user_id)
    {
        global $dbh;
        global $default_display_language;

        if (isset($_SESSION["display_language"])) {
           $display_language = trim($_SESSION["display_language"]);
        } else {
           $sth = $dbh->prepare("SELECT language FROM maia_users WHERE id = ?");
           $res = $sth->execute(array($user_id));
           if ($row = $res->fetchrow()) {
               $display_language = strtolower($row["language"]);
               $_SESSION["display_language"] = $display_language;
           } else {
               $display_language = $default_display_language;
           }
           $sth->free();
        }

        return $display_language;
    }


    /*
    * get_user_value(): Returns a value corresponding to a single
    *                   key from a user's personal settings.  This
    *                   is a convenient way to read one configuration
    *                   setting, but if multiple configuration settings
    *                   are required, it becomes more efficient to use
    *                   a manual query, rather than calling this
    *                   function repeatedly.
    */
    function get_user_value($user_id, $key)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT " . $key . " FROM maia_users WHERE id = ?");
        $res = $sth->execute(array($user_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }

        if ($row = $res->fetchrow()) {
           $value = $row[$key];
        }
        $sth->free();
        return $value;
    }

    /*
    * get_maia_user_row(): Returns a hash corresponding to a user's personal settings.
    *                      Call this to get all values in a user's config.
    */
    function get_maia_user_row($user_id)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT * FROM maia_users WHERE id = ? LIMIT 1");
        $res = $sth->execute(array($user_id));
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }

        if ($row = $res->fetchrow()) {
           $value = $row;
        }
        $sth->free();
        return $value;
    }

