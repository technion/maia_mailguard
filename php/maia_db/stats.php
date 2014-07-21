<?php


    /*
     * update_mail_stats(): Recalculate the statistics of the specified
     *                      type (suspected spam/ham), to ensure their
     *                      integrity after items of this type have been
     *                      deleted.
     */
    function update_mail_stats($user_id, $type)
    {
        global $dbh;

        if ($type == "suspected_spam") {
            $token = "AND maia_mail_recipients.type IN ('S','P') ";
        } elseif ($type == "suspected_ham") {
            $token = "AND maia_mail_recipients.type = 'H' ";
        } else {
            $token = "AND maia_mail_recipients.type = '' "; // shouldn't even be valid
        }

        if (!empty($token)) {

            $sth = $dbh->prepare("SELECT MIN(received_date) AS mindate, " .
                             "MAX(received_date) AS maxdate, " .
                             "MIN(score) AS minscore, " .
                             "MAX(score) AS maxscore, " .
                             "SUM(score) AS totalscore, " .
                             "MIN(size) AS minsize, " .
                             "MAX(size) AS maxsize, " .
                             "SUM(size) AS totalsize, " .
                             "COUNT(id) AS items " .
                      "FROM maia_mail, maia_mail_recipients " .
                      "WHERE maia_mail.id = maia_mail_recipients.mail_id " .
                      $token .
                      "AND maia_mail_recipients.recipient_id = ?");
            $res = $sth->execute(array($user_id));
            sql_check($sth, "update_mail_stats", $res);

            if ($row = $res->fetchrow()) {

              $sth2 = $dbh->prepare("SELECT user_id FROM maia_stats WHERE user_id = ?");
              $res2 = $sth2->execute(array($user_id));
              sql_check($sth2, "update_mail_stats", $sth2);

              // User already has a stats record, update it.
              if ($res2->fetchrow()) {
                    $updatesth = $dbh->prepare("UPDATE maia_stats SET oldest_" . $type . "_date = ?, " .
                                                    "newest_" . $type . "_date = ?, " .
                                                    "lowest_" . $type . "_score = ?, " .
                                                    "highest_" . $type . "_score = ?, " .
                                                    "total_" . $type . "_score = ?, " .
                                                    "smallest_" . $type . "_size = ?, " .
                                                    "largest_" . $type . "_size = ?, " .
                                                    "total_" . $type . "_size = ?, " .
                                                    "total_" . $type . "_items = ? " .
                              "WHERE user_id = ?");
                    $res = $updatesth->execute(array($row["mindate"],
                                               $row["maxdate"],
                                               (isset($row["minscore"]) ? $row["minscore"] : 0),
                                               (isset($row["maxscore"]) ? $row["maxscore"] : 0),
                                               (isset($row["totalscore"]) ? $row["totalscore"] : 0),
                                               (isset($row["minsize"]) ? $row["minsize"] : 0),
                                               (isset($row["maxsize"]) ? $row["maxsize"] : 0),
                                               (isset($row["totalsize"]) ? $row["totalsize"] : 0),
                                               (isset($row["items"]) ? $row["items"] : 0),
                                               $user_id));
                    sql_check($res, "update_mail_stats", $updatesth);

                // User doesn't have a stats record yet, create a new one for him.
                } else {
                    $insertsth = $dbh->prepare("INSERT INTO maia_stats (oldest_" . $type . "_date, " .
                                                      "newest_" . $type . "_date, " .
                                                      "lowest_" . $type . "_score, " .
                                                      "highest_" . $type . "_score, " .
                                                      "total_" . $type . "_score, " .
                                                      "smallest_" . $type . "_size, " .
                                                      "largest_" . $type . "_size, " .
                                                      "total_" . $type . "_size, " .
                                                      "total_" . $type . "_items, " .
                                                      "user_id) " .
                              "VALUES (?,?,?,?,?,?,?,?,?,?)");
                    $res = $insertsth->execute( array($row["mindate"],
                                               $row["maxdate"],
                                               (isset($row["minscore"]) ? $row["minscore"] : 0),
                                               (isset($row["maxscore"]) ? $row["maxscore"] : 0),
                                               (isset($row["totalscore"]) ? $row["totalscore"] : 0),
                                               (isset($row["minsize"]) ? $row["minsize"] : 0),
                                               (isset($row["maxsize"]) ? $row["maxsize"] : 0),
                                               (isset($row["totalsize"]) ? $row["totalsize"] : 0),
                                               (isset($row["items"]) ? $row["items"] : 0),
                                               $user_id));
                    if (PEAR::isError($sth)) { 
                        die($sth->getMessage()); 
                    } 
                }
                $sth2->free();
            }
            $sth->free();
        }
    }


    /*
     * record_mail_stats(): Recalculate the specified users' stats records
     *                      for items of the specified (static) type, after
     *                      suspected [spam|ham] is confirmed.
     */
    function record_mail_stats($euid, $mail_ids, $type)
    {
        global $dbh;
        foreach ((array)$mail_ids as $mail_id) {
          $sth = $dbh->prepare("SELECT received_date, size, score " .
                    "FROM maia_mail WHERE id = ?");
          $res = $sth->execute(array($mail_id));
          if (PEAR::isError($sth)) {
              die($sth->getMessage());
          }
          if ($row = $res->fetchrow()) {
              $mail_received_date = $row["received_date"];
              $mail_size = $row["size"];
              $mail_score = (isset($row["score"]) ? $row["score"] : 0);

              $sth2 = $dbh->prepare("SELECT oldest_" . $type . "_date, " .
                               "newest_" . $type . "_date, " .
                               "lowest_" . $type . "_score, " .
                               "highest_" . $type . "_score, " .
                               "total_" . $type . "_score, " .
                               "smallest_" . $type . "_size, " .
                               "largest_" . $type . "_size, " .
                               "total_" . $type . "_size, " .
                               "total_" . $type . "_items " .
                        "FROM maia_stats WHERE user_id = ?");
              $res2 = $sth2->execute(array($euid));
              if (PEAR::isError($sth2)) {
                  die($sth->getMessage());
              }
              if ($row2 = $res2->fetchrow()) {
                  $oldest_date = $row2["oldest_" . $type . "_date"];
                  $newest_date = $row2["newest_" . $type . "_date"];
                  $lowest_score = $row2["lowest_" . $type . "_score"];
                  $highest_score = $row2["highest_" . $type . "_score"];
                  $total_score = $row2["total_" . $type . "_score"];
                  $smallest_size = $row2["smallest_" . $type . "_size"];
                  $largest_size = $row2["largest_" . $type . "_size"];
                  $total_size = $row2["total_" . $type . "_size"];
                  $total_items = $row2["total_" . $type . "_items"];

                  if ($total_items == 0) {
                      $oldest_date = $mail_received_date;
                      $newest_date = $mail_received_date;
                      $lowest_score = $mail_score;
                      $highest_score = $mail_score;
                      $total_score = $mail_score;
                      $smallest_size = $mail_size;
                      $largest_size = $mail_size;
                      $total_size = $mail_size;
                      $total_items = 1;
                  } else {
                      if ($oldest_date == NULL || $mail_received_date < $oldest_date) {
                          $oldest_date = $mail_received_date;
                      }
                      if ($mail_received_date > $newest_date) {
                          $newest_date = $mail_received_date;
                      }
                      if ($mail_score < $lowest_score) {
                          $lowest_score = $mail_score;
                      }
                      if ($mail_score > $highest_score) {
                          $highest_score = $mail_score;
                      }
                      $total_score += $mail_score;
                      if ($mail_size < $smallest_size) {
                          $smallest_size = $mail_size;
                      }
                      if ($mail_size > $largest_size) {
                          $largest_size = $mail_size;
                      }
                      $total_size += $mail_size;
                      $total_items++;
                  }
                  $sthu = $dbh->prepare("UPDATE maia_stats SET oldest_" . $type . "_date = ?, " .
                                                  "newest_" . $type . "_date = ?, " .
                                                  "lowest_" . $type . "_score = ?, " .
                                                  "highest_" . $type . "_score = ?, " .
                                                  "total_" . $type . "_score = ?, " .
                                                  "smallest_" . $type . "_size = ?, " .
                                                  "largest_" . $type . "_size = ?, " .
                                                  "total_" . $type . "_size = ?, " .
                                                  "total_" . $type . "_items = ? " .
                            "WHERE user_id = ?");
                  $sthu->execute(array($oldest_date,
                                             $newest_date,
                                             $lowest_score,
                                             $highest_score,
                                             $total_score,
                                             $smallest_size,
                                             $largest_size,
                                             $total_size,
                                             $total_items,
                                             $euid));
                 if (PEAR::isError($sthu)) {
                     die($sth->getMessage());
                 }
                 $sthu->free();
              } else {
                  $oldest_date = $mail_received_date;
                  $newest_date = $mail_received_date;
                  $lowest_score = $mail_score;
                  $highest_score = $mail_score;
                  $total_score = $mail_score;
                  $smallest_size = $mail_size;
                  $largest_size = $mail_size;
                  $total_size = $mail_size;
                  $sthi = $dbh->prepare("INSERT INTO maia_stats (oldest_" . $type . "_date, " .
                                                    "newest_" . $type . "_date, " .
                                                    "lowest_" . $type . "_score, " .
                                                    "highest_" . $type . "_score, " .
                                                    "total_" . $type . "_score, " .
                                                    "smallest_" . $type . "_size, " .
                                                    "largest_" . $type . "_size, " .
                                                    "total_" . $type . "_size, " .
                                                    "total_" . $type . "_items, " .
                                                    "user_id) " .
                            "VALUES (?,?,?,?,?,?,?,?,1,?)");
                  $sthi->execute(array($oldest_date,
                                             $newest_date,
                                             $lowest_score,
                                             $highest_score,
                                             $total_score,
                                             $smallest_size,
                                             $largest_size,
                                             $total_size,
                                             $euid));
                  if (PEAR::isError($sth)) {
                      die($sth->getMessage());
                  }
                  $sthi->free();
              }
              $sth2->free();
          }
          $sth->free();
        }
    }

    /*
     *  function count_cache_items($euid) returns an
     *      array of item counts for a given user
     *  Combines type 'P' labeled with type 'S' quarantined suspected spam
     */
    function count_cache_items($euid) 
    {
        if ($euid == 0) {
          return array(); // at some time, we may want to return the total count,
                          // but the current desert_sand theme calls this during
                          // login.php, and that could be an expensive query.
        }
        global $dbh;
        $sth = $dbh->prepare( "SELECT type,
                          COUNT(mail_id) AS qcount,
                          MAX(mail_id) AS maxid
                   FROM maia_mail_recipients
                   WHERE recipient_id = ?
                   GROUP BY type");
        $res = $sth->execute(array($euid));
        static $results = array();
        if (empty($results)) {  // cached if called multiple times in one page load.
            while ($row = $res->fetchRow()) {
                $results[$row['type']] = array('count' => $row['qcount'],
                                               'max'   => $row['maxid']);
            }
            $sth->free();
        }

        if (array_key_exists('P', $results)) { //need to combine/transfer to type  'S'
            if (array_key_exists('S', $results)) {
                $results['S']['count'] += $results['P']['count'];
                $results['S']['max'] = max($results['P']['max'], $results['S']['max']);
            } else {
                $results['S'] = array('count' => $results['P']['count'],
                                      'max'   => $results['P']['max']);
            }
            unset($results['P']);
        }

        return $results;
    }


    /*
     * count_total_mail(): Returns the total number of mail items received
     *                     by the specified user, or by all users if $user_id == 0.
     */
    function count_total_mail($user_id)
    {
        global $dbh;

        $sth = $dbh->prepare("SELECT enable_false_negative_management, " .
                         "enable_virus_scanning, enable_spam_filtering, " .
                         "enable_bad_header_checking, enable_banned_files_checking " .
                  "FROM maia_config WHERE id = 0");
        $res = $sth->execute();
        if (PEAR::isError($sth)) {
             die($sth->getMessage());
        }

        if ($row = $res->fetchrow()) {
            $enable_false_negative_management = ($row["enable_false_negative_management"] == 'Y');
            $enable_virus_scanning = ($row["enable_virus_scanning"] == 'Y');
            $enable_spam_filtering = ($row["enable_spam_filtering"] == 'Y');
            $enable_bad_header_checking = ($row["enable_bad_header_checking"] == 'Y');
            $enable_banned_files_checking = ($row["enable_banned_files_checking"] == 'Y');
        }
        $sth->free();

        if ($user_id > 0) {
            $prefix = "SELECT (";
            $suffix = " WHERE user_id = ?";
        } else {
            $prefix = "SELECT SUM(";
            $suffix = "";
        }
        $select = $prefix . "total_ham_items + " .
                      "total_wl_items + " .
                            "total_bl_items";
        if ($enable_spam_filtering) {
            $select .= " + total_fp_items" .
                       " + total_suspected_spam_items" .
                       " + total_spam_items";
            if ($enable_false_negative_management) {
                $select .= " + total_suspected_ham_items" .
                           " + total_fn_items";
            }
          }
          if ($enable_virus_scanning) {
            $select .= " + total_virus_items";
        }
        if ($enable_bad_header_checking) {
            $select .= " + total_bad_header_items";
        }
        if ($enable_banned_files_checking) {
            $select .= " + total_banned_file_items";
        }
        $select .= ") AS count FROM maia_stats" . $suffix;
        $sth = $dbh->prepare($select);

        if ($user_id > 0) {
            $res = $sth->execute(array($user_id));
        } else {
            $res = $sth->execute();
        }
        if (PEAR::isError($sth)) {
             die($sth->getMessage());
        }

        $count = 0;
        if ($row = $res->fetchrow()) {
            $count = $row["count"];
        }
        $sth->free();

        return $count;
    }


    /*
     * count_item_days(): Returns the number of days between the oldest and
     *                    newest mail item of the specified type received by
     *                    the specified user, or all users if $user_id == 0.
     *                    $type can be one of:
     *
     *                        "suspected_ham"  : Suspected Ham
     *                        "ham"            : Confirmed Ham
     *                        "suspected_spam" : Suspected Spam
     *                        "spam"           : Confirmed Spam
     *                        "wl"             : Whitelisted Sender
     *                        "bl"             : Blacklisted Sender
     *                        "fp"             : False Positive
     *                        "fn"             : False Negative
     *                        "virus"          : Virus/Malware
     *                        "banned_file"    : Banned File Attachment
     *                        "bad_header"     : Invalid Mail Header
     */
    function count_item_days($user_id, $type)
    {
        global $dbh;

        if ($user_id > 0) {
            $sth = $dbh->prepare("SELECT oldest_" . $type . "_date AS mindate FROM maia_stats WHERE user_id = ?");
            $res = $sth->execute(array($user_id));
        } else {
            $sth = $dbh->prepare("SELECT MIN(oldest_" . $type . "_date) AS mindate FROM maia_stats");
            $res = $sth->execute();
        }
        if (PEAR::isError($sth)) {
             die($sth->getMessage());
        }

        $days = 0.0;
        if ($row = $res->fetchrow()) {
            sscanf($row["mindate"], "%d-%d-%d %d:%d:%d", $year, $mon, $day, $hour, $min, $sec);
            $tstamp = mktime($hour, $min, $sec, $mon, $day, $year);
            $days = ((time() - $tstamp) / (24 * 60 * 60));
        }
        $sth->free();

        return $days;
    }


    /*
     * lowest_item_score(): Returns the lowest SpamAssassin score recorded
     *                      for a mail item of the specified type for the
     *                      specified user, or all users if $user_id == 0.
     *                      $type can be one of:
     *
     *                          "suspected_ham"  : Suspected Ham
     *                          "ham"            : Confirmed Ham
     *                          "suspected_spam" : Suspected Spam
     *                          "spam"           : Confirmed Spam
     *                          "fp"             : False Positive
     *                          "fn"             : False Negative
     */
    function lowest_item_score($user_id, $type)
    {
      global $dbh;

      if ($user_id > 0) {
          $sth = $dbh->prepare("SELECT lowest_" . $type . "_score AS score FROM maia_stats " .
                    "WHERE user_id = ? AND lowest_" . $type . "_score > -999");
          $res = $sth->execute(array($user_id));
      } else {
          $sth = $dbh->prepare("SELECT MIN(lowest_" . $type . "_score) AS score FROM maia_stats " .
                    "WHERE lowest_" . $type . "_score > -999");
          $res = $sth->execute();
      }
      if (PEAR::isError($sth)) {
           die($sth->getMessage());
      }

      $score = 0;
      if ($row = $res->fetchrow()) {
        $score = $row["score"];
      }
      $sth->free();

      return $score;
    }


    /*
     * highest_item_score(): Returns the highest SpamAssassin score recorded
     *                       for a mail item of the specified type for the
     *                       specified user, or all users if $user_id == 0.
     *                       $type can be one of:
     *
     *                           "suspected_ham"  : Suspected Ham
     *                           "ham"            : Confirmed Ham
     *                           "suspected_spam" : Suspected Spam
     *                           "spam"           : Confirmed Spam
     *                           "fp"             : False Positive
     *                           "fn"             : False Negative
     */
    function highest_item_score($user_id, $type)
    {
      global $dbh;

      if ($user_id > 0) {
          $sth = $dbh->prepare("SELECT highest_" . $type . "_score AS score FROM maia_stats " .
                    "WHERE user_id = ? AND highest_" . $type . "_score < 999");
          $res = $sth->execute(array($user_id));
      } else {
          $sth = $dbh->prepare("SELECT MAX(highest_" . $type . "_score) AS score FROM maia_stats " .
                    "WHERE highest_" . $type . "_score < 999");
          $res = $sth->execute();
      }
      if (PEAR::isError($sth)) {
           die($sth->getMessage());
      }

      $score = 0;
      if ($row = $res->fetchrow()) {
          $score = $row["score"];
      }
      $sth->free();

      return $score;
    }


    /*
     * total_item_score(): Returns the sum of all SpamAssassin scores
     *                     recorded for a mail item of the specified
     *                     type for the specified user, or all users
     *                     if $user_id == 0.  $type can be one of:
     *
     *                         "suspected_ham"  : Suspected Ham
     *                         "ham"            : Confirmed Ham
     *                         "suspected_spam" : Suspected Spam
     *                         "spam"           : Confirmed Spam
     *                         "fp"             : False Positive
     *                         "fn"             : False Negative
     */
    function total_item_score($user_id, $type)
    {
        global $dbh;

        if ($user_id > 0) {
            $sth = $dbh->prepare("SELECT total_" . $type . "_score AS score FROM maia_stats WHERE user_id = ?");
            $res = $sth->execute(array($user_id));
        } else {
            $sth = $dbh->prepare("SELECT SUM(total_" . $type . "_score) AS score FROM maia_stats");
            $res = $sth->execute();
        }
        if (PEAR::isError($sth)) {
             die($sth->getMessage());
        }

        $score = 0;
        if ($row = $res->fetchrow()) {
            $score = $row["score"];
        }
        $sth->free();

        return $score;
    }


    /*
     * smallest_item_size(): Returns the size of the smallest mail item
     *                       of the specified type received by the specified
     *                       user, or all users if $user_id == 0.  $type can
     *                       be one of:
     *
     *                           "suspected_ham"  : Suspected Ham
     *                           "ham"            : Confirmed Ham
     *                           "suspected_spam" : Suspected Spam
     *                           "spam"           : Confirmed Spam
     *                           "wl"             : Whitelisted Sender
     *                           "bl"             : Blacklisted Sender
     *                           "fp"             : False Positive
     *                           "fn"             : False Negative
     *                           "virus"          : Virus/Malware
     *                           "banned_file"    : Banned File Attachment
     *                           "bad_header"     : Invalid Mail Header
     */
    function smallest_item_size($user_id, $type)
    {
        global $dbh;

        if ($user_id > 0) {
            $sth = $dbh->prepare("SELECT smallest_" . $type . "_size AS size FROM maia_stats WHERE user_id = ? AND smallest_" .
                      $type . "_size > 0");
            $res = $sth->execute(array($user_id));
        } else {
            $sth = $dbh->prepare("SELECT MIN(smallest_" . $type . "_size) AS size FROM maia_stats WHERE smallest_" . $type .
                      "_size > 0");
            $res = $sth->execute();
        }
        if (PEAR::isError($sth)) {
             die($sth->getMessage());
        }

        $size = 0;
        if ($row = $res->fetchrow()) {
            $size = $row["size"];
        }
        $sth->free();

        return $size;
    }


    /*
     * largest_item_size(): Returns the size of the largest mail item
     *                      of the specified type received by the specified
     *                      user, or all users if $user_id == 0.  $type can
     *                      be one of:
     *
     *                          "suspected_ham"  : Suspected Ham
     *                          "ham"            : Confirmed Ham
     *                          "suspected_spam" : Suspected Spam
     *                          "spam"           : Confirmed Spam
     *                          "wl"             : Whitelisted Sender
     *                          "bl"             : Blacklisted Sender
     *                          "fp"             : False Positive
     *                          "fn"             : False Negative
     *                          "virus"          : Virus/Malware
     *                          "banned_file"    : Banned File Attachment
     *                          "bad_header"     : Invalid Mail Header
     */
    function largest_item_size($user_id, $type)
    {
        global $dbh;

        if ($user_id > 0) {
            $sth = $dbh->prepare("SELECT largest_" . $type . "_size AS size FROM maia_stats WHERE user_id = ?");
            $res = $sth->execute(array($user_id));
        } else {
            $sth = $dbh->prepare("SELECT MAX(largest_" . $type . "_size) AS size FROM maia_stats");
            $res = $sth->execute();
        }
        if (PEAR::isError($sth)) {
             die($sth->getMessage());
        }

        $size = 0;
        if ($row = $res->fetchrow()) {
            $size = $row["size"];
        }
        $sth->free();

        return $size;
    }


    /*
     * total_item_size(): Returns the sum of the sizes of all mail items
     *                    of the specified type received by the specified
     *                    user, or all users if $user_id == 0.  $type can
     *                    be one of:
     *
     *                        "suspected_ham"  : Suspected Ham
     *                        "ham"            : Confirmed Ham
     *                        "suspected_spam" : Suspected Spam
     *                        "spam"           : Confirmed Spam
     *                        "wl"             : Whitelisted Sender
     *                        "bl"             : Blacklisted Sender
     *                        "fp"             : False Positive
     *                        "fn"             : False Negative
     *                        "virus"          : Virus/Malware
     *                        "banned_file"    : Banned File Attachment
     *                        "bad_header"     : Invalid Mail Header
     */
    function total_item_size($user_id, $type)
    {
        global $dbh;

        if ($user_id > 0) {
            $sth = $dbh->prepare("SELECT total_" . $type . "_size AS size FROM maia_stats WHERE user_id = ?");
            $res = $sth->execute(array($user_id));
        } else {
            $sth = $dbh->prepare("SELECT SUM(total_" . $type . "_size) AS size FROM maia_stats");
            $res = $sth->execute();
        }
        if (PEAR::isError($sth)) {
             die($sth->getMessage());
        }

        $size = 0;
        if ($row = $res->fetchrow()) {
            $size = $row["size"];
        }
        $sth->free();

        return $size;
    }


    /*
     * count_items(): Returns the total number of mail items of the specified
     *                type received by the specified user, or all users if
     *                $user_id == 0.  $type can be one of:
     *
     *                    "suspected_ham"  : Suspected Ham
     *                    "ham"            : Confirmed Ham
     *                    "suspected_spam" : Suspected Spam
     *                    "spam"           : Confirmed Spam
     *                    "wl"             : Whitelisted Sender
     *                    "bl"             : Blacklisted Sender
     *                    "fp"             : False Positive
     *                    "fn"             : False Negative
     *                    "virus"          : Virus/Malware
     *                    "banned_file"    : Banned File Attachment
     *                    "bad_header"     : Invalid Mail Header
     */
    function count_items($user_id, $type)
    {
        global $dbh;

        if ($user_id > 0) {
            $sth = $dbh->prepare("SELECT total_" . $type . "_items AS count FROM maia_stats WHERE user_id = ?");
            $res = $sth->execute(array($user_id));
            if (PEAR::isError($sth)) {
                die($sth->getMessage());
            }
        } else {
            $sth = $dbh->prepare("SELECT SUM(total_" . $type . "_items) AS count FROM maia_stats");
            $res = $sth->execute();
            if (PEAR::isError($sth)) {
                die($sth->getMessage());
            }
        }

        $count = 0;
        if ($row = $res->fetchRow()) {
            $count = $row["count"];
        }
        $sth->free();

        return $count;
    }


    /*
     * calculate_ppv(): Calculates the Positive Predictive Value (PPV), which is
      *                  the percentage of Suspected Spam that ultimately becomes
      *                  Confirmed Spam.
      */
    function calculate_ppv($spam, $fp)
    {
        $total = $spam + $fp;
        if ($total > 0) {
            return ($spam / $total);
        } else {
            return 0;
        }
    }


    /*
    * calculate_npv(): Calculates the Negative Predictive Value (NPV), which is
    *                  the percentage of Suspected Ham that ultimately becomes
    *                  Confirmed Ham.
    */
    function calculate_npv($ham, $fn)
    {
        $total = $ham + $fn;
        if ($total > 0) {
            return ($ham / $total);
        } else {
            return 0;
        }
    }


    /*
    * calculate_sensitivity(): Calculates the statistical sensitivity, which is
    *                          the percentage of Confirmed Spam that was properly
    *                          diagnosed as Suspected Spam.
    */
    function calculate_sensitivity($spam, $fn)
    {
        $total = $spam + $fn;
        if ($total > 0) {
            return ($spam / $total);
        } else {
            return 0;
        }
    }


    /*
    * calculate_specificity(): Calculates the statistical specificity, which is
    *                          the percentage of Confirmed Ham that was properly
    *                          diagnosed as Suspected Ham.
    */
    function calculate_specificity($ham, $fp)
    {
        $total = $ham + $fp;
        if ($total > 0) {
            return ($ham / $total);
        } else {
            return 0;
        }
    }


    /*
    * calculate_efficiency(): Calculates the statistical efficiency, which is the
    *                         percentage of the time SpamAssassin diagnosed the
    *                         mail's status correctly.
    */
    function calculate_efficiency($spam, $ham, $fp, $fn)
    {
        $total = $spam + $ham + $fp + $fn;
        if ($total > 0) {
            return (($spam + $ham) / $total);
        } else {
            return 0;
        }
    }


    /*
    * get_filter_stats():
    */
    function get_filter_stats($user_id)
    {
        global $dbh;

        $enable_false_negative_management = (get_config_value("enable_false_negative_management") == 'Y');
        if ($user_id > 0) {
            $sth = $dbh->prepare("SELECT total_ham_items AS total_ham, " .
                             "total_spam_items AS total_spam, " .
                             "total_fp_items AS total_fp, " .
                             "total_fn_items AS total_fn " .
                      "FROM maia_stats WHERE user_id = ?");
            $res = $sth->execute(array($user_id));
        } else {
            $sth = $dbh->prepare("SELECT SUM(total_ham_items) AS total_ham, " .
                             "SUM(total_spam_items) AS total_spam, " .
                             "SUM(total_fp_items) AS total_fp, " .
                             "SUM(total_fn_items) AS total_fn " .
                      "FROM maia_stats");
            $res = $sth->execute();
        }
        if (PEAR::isError($sth)) {
            die($sth->getMessage());
        }
        $fp_pct = 0;
        $fn_pct = 0;
        $ppv_pct = 0;
        $npv_pct = 0;
        $sensitivity_pct = 0;
        $specificity_pct = 0;
        $efficiency_pct = 0;
        if ($row = $res->fetchrow()) {
            $ham = $row["total_ham"];
            $spam = $row["total_spam"];
            $fp = $row["total_fp"];
            $fn = $row["total_fn"];
            $ppv_pct = calculate_ppv($spam, $fp);
            $specificity_pct = calculate_specificity($ham, $fp);
            if ($enable_false_negative_management) {
                  $npv_pct = calculate_npv($ham, $fn);
                  $sensitivity_pct = calculate_sensitivity($spam, $fn);
                  $efficiency_pct = calculate_efficiency($spam, $ham, $fp, $fn);
                  if ($ham + $spam + $fp + $fn > 0) {
                      $fp_pct = $fp / ($ham + $spam + $fp + $fn);
                      $fn_pct = 1 - $efficiency_pct - $fp_pct;
                  } else {
                      $fp_pct = 0;
                      $fn_pct = 0;
                  }
            } else {
                  $npv = 1;
                  $sensitivity_pct = 1;
                  $efficiency_pct = calculate_efficiency($spam, $ham, $fp, 0);
                  if ($ham + $spam + $fp > 0) {
                      $fp_pct = 1 - $efficiency_pct;
                  } else {
                      $fp_pct = 0;
                  }
                  $fn_pct = 0;
            }
        }
        $sth->free();

        return array($ppv_pct, $npv_pct, $sensitivity_pct, $specificity_pct,
                          $efficiency_pct, $fp_pct, $fn_pct);
    }
