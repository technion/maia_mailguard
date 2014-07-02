<?php
    /*
     * delete_mail(): Deletes mail items and all references
     *                to them.
     */
    function delete_mail($mail_ids)
    {
        global $dbh;

        if (count($mail_ids) < 1) { #not sure if this  is possible, but
            return;                  # we should not do anything if the list is empty
        }

        // Delete any references to recipients
        $delete = "DELETE FROM maia_mail_recipients WHERE mail_id IN (?" . str_repeat(',?', count($mail_ids) - 1) . ")";
        $res = $dbh->query($delete, $mail_ids);
        sql_check($res,"delete_mail",$delete);

        // Delete any references to SpamAssassin rules
        $delete = "DELETE FROM maia_sa_rules_triggered WHERE mail_id IN (?" . str_repeat(',?', count($mail_ids) - 1) . ")";
        $res = $dbh->query($delete, $mail_ids);
        sql_check($res,"delete_mail",$delete);

        // Delete any references to viruses
        $delete = "DELETE FROM maia_viruses_detected WHERE mail_id IN (?" . str_repeat(',?', count($mail_ids) - 1) . ")";
        $res = $dbh->query($delete, $mail_ids);
        sql_check($res,"delete_mail",$delete);

        // Delete any references to banned file attachments
        $delete = "DELETE FROM maia_banned_attachments_found WHERE mail_id IN (?" . str_repeat(',?', count($mail_ids) - 1) . ")";
        $res = $dbh->query($delete, $mail_ids);
        sql_check($res,"delete_mail",$delete);

        // Delete the mail item itself
        $delete = "DELETE FROM maia_mail WHERE id IN (?" . str_repeat(',?', count($mail_ids) - 1) . ")";
        $res = $dbh->query($delete, $mail_ids);
        sql_check($res,"delete_mail",$delete);
    }


    /*
     * delete_mail_references(): Deletes mail items' recipient
     *                           references.
     */
    function delete_mail_reference($user_id, $mail_ids)
    {
        global $dbh;
        global $logger;

        if (count($mail_ids) < 1) { #not sure if this  is possible, but
            return;                  # we should not do anything if the list is empty
        }

        // Delete a specific users' recipient reference to these mail messages.
        $delete = "DELETE FROM maia_mail_recipients WHERE recipient_id = ? AND mail_id IN (";
        $delete .= '?' . str_repeat(',?', count($mail_ids) - 1);
        $delete .= ")";

        $res = $dbh->query($delete, array_merge((array)$user_id, (array)$mail_ids));
        sql_check($res,"delete_mail_reference",$delete);

        // If there are no other recipients referenced by each mail item,
        // delete it.

        $select = "SELECT recipient_id, mail_id, maia_mail.id ".
        "FROM      maia_mail " .
        "LEFT JOIN maia_mail_recipients " .
               "ON maia_mail.id = maia_mail_recipients.mail_id " .
        "WHERE maia_mail.id IN (?" . str_repeat(',?', count($mail_ids) - 1) .") " .
          "AND mail_id IS NULL";
        $sth = $dbh->query($select, $mail_ids);
        sql_check($sth,"delete_mail_reference",$select);
        $deletions = array();

        while ($row = $sth->fetchrow() ) {
            array_push($deletions, $row['id']);
        }
        $sth->free();

        if (count($deletions) > 0) {
          delete_mail($deletions);
        }
    }


    /*
     * delete_user_mail_references(): Deletes all recipient mail references
     *                                for the specified user.
     */
    function delete_user_mail_references($uid)
    {
        global $dbh;

        // Delete recipient references to any mail items this user
        // might have.
        $select = "SELECT mail_id FROM maia_mail_recipients WHERE recipient_id = ?";
        $sth = $dbh->query($select, array($uid));
        sql_check($sth,"delete_user_mail_references",$select);
        while ($row = $sth->fetchRow()) {
            delete_mail_reference($uid, $row["mail_id"]);
        }
        $sth->free();
    }

    /* delete_domain_addresses()
     *
     * deletes all addresses/users that belong to the domain.
     */
    function delete_domain_addresses($domain)
    {
        global $dbh;
        $complete_success = true;

        $query = "SELECT id FROM users WHERE email LIKE ? AND email not like ?";
        $sth = $dbh->query($query, array('%'.$domain, $domain));
        while ($row = $sth->fetchrow()) {
            $return = smart_delete_email_address($row['id']);
            if (!$return) {
                $complete_success = false;
            }
        }
        return $complete_success;
    }


    /* update the confirmation settings on one or multiple items.   */
    function set_item_confirmations($message_type, $user_id, $mail_id) {
        global $dbh;
        if (substr(get_database_type($dbh),0,5) == "mysql") {
            $token_code = "CONCAT('expired-', recipient_id, '-', mail_id)";
        } else {
            $token_code = "'expired-' || recipient_id || '-' || mail_id";
        }
        $update = "UPDATE maia_mail_recipients SET type = ?, token=" . $token_code  .
                " WHERE recipient_id = ? AND mail_id IN (";

        $update .= '?' . str_repeat(',?', count($mail_id) - 1);

        $update .= ")";
        $res = $dbh->query($update, array_merge((array)$message_type, (array)$user_id, (array)$mail_id));
        sql_check($res,"set_item_confirmations",$update);
    }

     /*
      * report_spam(): Confirm mail item(s) as false negative spam.
             mail_id can be a scalar or an array
      */
    function report_spam($user_id, $mail_id)
    {
        global $dbh;

        // Mark the items as Confirmed Spam
        confirm_spam($user_id, $mail_id);

        // Also add the items to the Spam stats columns
        record_mail_stats($user_id, $mail_id, "fn");

    }

    /*
     * confirm_spam(): Confirm mail item(s) as spam.
                      mail_id can be a scalar or an array
     */
    function confirm_spam($user_id, $mail_id)
    {
        global $dbh;

        // Mark the items as Confirmed Spam
        set_item_confirmations('C', $user_id, $mail_id);

        // Add the items to the Spam stats columns
        record_mail_stats($user_id, $mail_id, "spam");
    }


    /*
     * confirm_ham(): Confirm mail item(s) as ham.
                      mail_id can be a scalar or an array
     */
    function confirm_ham($user_id, $mail_ids)
    {
        global $dbh;

        // Mark the items as Confirmed Ham
        set_item_confirmations('G', $user_id, $mail_ids);

        // Add the items to the Ham stats columns
        record_mail_stats($user_id, $mail_ids, "ham");
    }

    /*
     * resend_message():  Resend a message without changing any stats
     *
     */
     function resend_message($user_id, $mail_ids) 
     {
         $message = "";
         foreach ($mail_ids as $mail_id) {
            $message .= rescue_item($user_id,$mail_id, true);
         }
     }


    /*
     * rescue_item(): Rescues a mail item from quarantine and
     *                submits it for delivery.
     */
    function rescue_item($user_id, $mail_id, $resend=false)
    {
        global $dbh, $logger;

        $select = "SELECT sender_email, contents, " .
                         "envelope_to, maia_mail_recipients.type " .
                  "FROM maia_mail, maia_mail_recipients " .
                  "WHERE maia_mail.id = maia_mail_recipients.mail_id " .
                  "AND maia_mail_recipients.recipient_id = ? " .
                  "AND maia_mail_recipients.mail_id = ?";
        $sth = $dbh->query($select, array($user_id, $mail_id));
        sql_check($sth, "rescue_item", $select);

        if ($row = $sth->fetchrow()) {
          $sender_email = $row["sender_email"];
          $body = $row["contents"];
          $type = $row["type"];

            if (extension_loaded('mcrypt')) {
                if (text_is_encrypted($body)) {
                  $key = get_encryption_key();
                  $body = decrypt_text($key, $body);
              }
            }

          if (is_a_domain_default_user($user_id)) {

            // System default user (@.) or domain-class user (e.g. @domain)
            $my_email_address = $row["envelope_to"];

          } else {

            // Regular user (e.g. user@domain)
                $rlist = explode(" ", trim($row["envelope_to"]));
                $select = "SELECT email FROM users " .
                          "WHERE maia_user_id = ? " .
                          "AND email = ?";
                $my_email_address = "";
                foreach ($rlist as $rmail) {
                    $sth2 = $dbh->query($select, array($user_id, $rmail));
                    sql_check($sth2, "rescue_item", $select);
                    if ($row2 = $sth2->fetchrow()) {
                        $my_email_address = $row2["email"];
                        $sth2->free();
                        break;
                    }
                    $sth2->free();
                }

            }
            if (!empty($my_email_address)) {
                if ($resend || $type != 'P') {  // don't send if it is a labeled fp
                    $smtp_result = smtp_send($sender_email, $my_email_address, $body);
                } else {
                    $smtp_result = "200 no delivery needed";
                }
                if (($succeeded = (strncmp($smtp_result, "2", 1) == 0)) || $type == 'P') {
                  if (!$resend) {
                    if ($type == 'S' || $type == 'P') {
                        record_mail_stats($user_id, $mail_id, "fp");
                        if (get_user_value($user_id, "auto_whitelist") == "Y") {
                            add_address_to_wb_list($user_id, $sender_email, "W");
                        }
                    }
                    set_item_confirmations('G', $user_id, $mail_id);
                  }
                } else {
                    $logger->err("rescue attempt failed! " . $smtp_result);
                }
            } else {
                $smtp_result = $lang['text_rescue_error'] . "(EmptyAddress)"; // code really shouldn't be here.
            }
        } else {
            $smtp_result = $lang['text_rescue_error'] . "(MessageNotFound)"; // code really shouldn't be here.
        }
        $sth->free();
        $logger->info($smtp_result);
        return $smtp_result;
    }

