#!/usr/bin/perl

# $Id: send-quarantine-reminders.pl 1528 2011-05-31 10:09:15Z rjl $

########################################################################
# MAIA MAILGUARD LICENSE v.1.0
#
# Copyright 2004 by Robert LeBlanc <rjl@renaissoft.com>
#                   David Morton   <mortonda@dgrmm.net>
# All rights reserved.
#
# PREAMBLE
#
# This License is designed for users of Maia Mailguard
# ("the Software") who wish to support the Maia Mailguard project by
# leaving "Maia Mailguard" branding information in the HTML output
# of the pages generated by the Software, and providing links back
# to the Maia Mailguard home page.  Users who wish to remove this
# branding information should contact the copyright owner to obtain
# a Rebranding License.
#
# DEFINITION OF TERMS
#
# The "Software" refers to Maia Mailguard, including all of the
# associated PHP, Perl, and SQL scripts, documentation files, graphic
# icons and logo images.
#
# GRANT OF LICENSE
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# 3. The end-user documentation included with the redistribution, if
#    any, must include the following acknowledgment:
#
#    "This product includes software developed by Robert LeBlanc
#    <rjl@renaissoft.com>."
#
#    Alternately, this acknowledgment may appear in the software itself,
#    if and wherever such third-party acknowledgments normally appear.
#
# 4. At least one of the following branding conventions must be used:
#
#    a. The Maia Mailguard logo appears in the page-top banner of
#       all HTML output pages in an unmodified form, and links
#       directly to the Maia Mailguard home page; or
#
#    b. The "Powered by Maia Mailguard" graphic appears in the HTML
#       output of all gateway pages that lead to this software,
#       linking directly to the Maia Mailguard home page; or
#
#    c. A separate Rebranding License is obtained from the copyright
#       owner, exempting the Licensee from 4(a) and 4(b), subject to
#       the additional conditions laid out in that license document.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
########################################################################

    use DBI;
    use POSIX;
    use Net::SMTP;

    # constants
    use constant SECS_PER_HOUR => 60 * 60;
    use constant SECS_PER_DAY => SECS_PER_HOUR * 24;

    # prototypes
    sub fatal($);
    sub output($);

    # name of this script
    my $script_name = "send-quarantine-reminders";

    # read configuration file (/etc/maia/maia.conf)
    my $config_file = "/etc/maia/maia.conf";
    unless (my $rv = do $config_file) {
        fatal(sprintf("Couldn't parse %s: %s", $config_file, $@)) if $@;
        fatal(sprintf("Couldn't open %s", $config_file)) if (!defined($rv) || !$rv);
    };

    $pid_dir = "/var/run/maia" if !defined($pid_dir);

    $pid_file = "$pid_dir/.send-quarantine-reminders.pid";

    # Check for existing lock file, remove any stale locks
    if (open(PID_FILE, "< $pid_file\0")) {
        my $pid;
        while (<PID_FILE>) { chomp; $pid = $_ if /^\d+\z/ }
        close(PID_FILE) or fatal(sprintf("Can't close file %s: %s", $pid_file, $!));
        if (!defined($pid)) {
            if ($debug) {
                output("Removing invalid lock file...");
            }
            unlink($pid_file);
        } elsif (kill 0 => $pid) {
            if (!$quiet) {
                output(sprintf("Another instance [%d] is currently running.", $pid));
            }
            exit;
        } else {
            if ($debug) {
                output(sprintf("Removing stale lock file [%d]...", $pid));
            }
            unlink($pid_file);
        }
    }

    # Write lock file, store PID
    open(PID_FILE, "> $pid_file\0") or fatal(sprintf("Can't write lock file %s", $pid_file));
    print PID_FILE "$$";
    close(PID_FILE);

    my $dbh;

    # database configuration
    if (defined($dsn) && defined($username) && defined($password)) {
        $dbh = DBI->connect($dsn, $username, $password)
            or fatal("Can't connect to the Maia database (verify \$dsn, \$username, and \$password in maia.conf)");
    } else {
        fatal("Can't connect to the Maia database (missing \$dsn, \$username, or \$password in maia.conf)");
    }

    my($select, $sth, $sth2, @row, @row2, $user_id, $user_email);
    my($expiry_period, $ham_cache_expiry_period, $admin_email);
    my($reminder_login_url, $reminder_template_file, $smtp_server, $smtp_port);
    my($reminder_threshold_count, $reminder_threshold_size);
    $select = "SELECT expiry_period, " .
                     "admin_email, " .
                     "reminder_login_url, " .
                     "reminder_template_file, " .
                     "smtp_server, " .
                     "smtp_port, " .
                     "reminder_threshold_count, " .
                     "reminder_threshold_size " .
              "FROM maia_config WHERE id = 0";
    $sth = $dbh->prepare($select)
               or fatal(sprintf("Couldn't prepare query: %s", $dbh->errstr));
    $sth->execute()
        or fatal(sprintf("Couldn't execute query: %s", $dbh->errstr));
    if (@row = $sth->fetchrow_array()) {
        $expiry_period = $1 if $row[0] =~ /^([0-9]+)$/si; # untaint
        $admin_email = $1 if $row[1] =~ /^(.+\@.+)$/si; # untaint
        $reminder_login_url = $1 if $row[2] =~ /^(https?\:\/\/.+\..+)$/si; # untaint
        $reminder_template_file = $1 if $row[3] =~ /^(.+)$/si; # untaint
        $smtp_server = $1 if $row[4] =~ /^(.+)$/si; # untaint
        $smtp_port = $1 if $row[5] =~ /^([1-9]+[0-9]*)$/si; # untaint
        $reminder_threshold_count = $1 if $row[6] =~ /^([0-9]+)$/si; # untaint
        $reminder_threshold_size = $1 if $row[7] =~ /^([0-9]+)$/si; # untaint
    }
    $sth->finish;

    # Read the e-mail template file into memory
    open TEMPLATEFILE, "<" . $reminder_template_file
       or fatal(sprintf("Unable to read %s", $reminder_template_file));
    my($template) = "";
    while ($line = <TEMPLATEFILE>) {
       $template .= $line;
    }
    close TEMPLATEFILE;

    $select = "SELECT maia_users.id, users.email, " .
                     "policy.bypass_virus_checks, " .
                     "policy.bypass_spam_checks, " .
                     "policy.bypass_banned_checks, " .
                     "policy.bypass_header_checks " .
              "FROM maia_users, users, policy " .
              "WHERE maia_users.id = users.maia_user_id " .
              "AND policy.id = users.policy_id " .
              "AND maia_users.primary_email_id = users.id " .
              "AND maia_users.reminders = 'Y'";
    $sth = $dbh->prepare($select)
               or fatal(sprintf("Couldn't prepare query: %s", $dbh->errstr));
    $sth->execute()
        or fatal(sprintf("Couldn't execute query: %s", $dbh->errstr));
    while (@row = $sth->fetchrow_array()) {
        $user_id = $1 if $row[0] =~ /^([1-9]+[0-9]*)$/si; # untaint
        $user_email = $1 if $row[1] =~ /^(.+\@.+)$/si; # untaint
        $bypass_virus_checks = $1 if $row[2] =~ /^([YN])$/si; # untaint;
        $bypass_spam_checks = $1 if $row[3] =~ /^([YN])$/si; # untaint;
        $bypass_banned_checks = $1 if $row[4] =~ /^([YN])$/si; # untaint;
        $bypass_header_checks = $1 if $row[5] =~ /^([YN])$/si; # untaint;

        # Count pending viruses
        my $vcount = 0;
        my $oldest_virus = "";
        my $vsize = 0;
        if (!($bypass_virus_checks eq 'Y')) {
            $select = "SELECT COUNT(maia_mail_recipients.mail_id) AS vcount, " .
                             "MIN(maia_mail.received_date) AS oldestvirus, " .
                             "SUM(maia_mail.size) AS vsize " .
                      "FROM maia_mail, maia_mail_recipients " .
                      "WHERE maia_mail.id = maia_mail_recipients.mail_id " .
                      "AND maia_mail_recipients.recipient_id = ? " .
                      "AND maia_mail_recipients.type = 'V'";
            $sth2 = $dbh->prepare($select)
                       or fatal(sprintf("Couldn't prepare query: %s", $dbh->errstr));
            $sth2->execute($user_id)
                or fatal(sprintf("Couldn't execute query: %s", $dbh->errstr));
            if (@row2 = $sth2->fetchrow_array()) {
                $vcount = $1 if $row2[0] =~ /^([0-9]+)$/si; # untaint
                $oldest_virus = $1 if $row2[1] =~ /^(.+)$/si; # untaint
                $vsize = $1 if $row2[2] =~ /^([0-9]+)$/si; # untaint
            }
            $sth2->finish;
        }

        # Count pending suspected spam
        my $scount = 0;
        my $oldest_spam = "";
        my $ssize = 0;
        if (!($bypass_spam_checks eq 'Y')) {
            $select = "SELECT COUNT(maia_mail_recipients.mail_id) AS scount, " .
                             "MIN(maia_mail.received_date) AS oldestspam, " .
                             "SUM(maia_mail.size) AS ssize " .
                      "FROM maia_mail, maia_mail_recipients " .
                      "WHERE maia_mail.id = maia_mail_recipients.mail_id " .
                      "AND maia_mail_recipients.recipient_id = ? " .
                      "AND maia_mail_recipients.type IN ('S','P')";
            $sth2 = $dbh->prepare($select)
                       or fatal(sprintf("Couldn't prepare query: %s", $dbh->errstr));
            $sth2->execute($user_id)
                or fatal(sprintf("Couldn't execute query: %s", $dbh->errstr));
            if (@row2 = $sth2->fetchrow_array()) {
                $scount = $1 if $row2[0] =~ /^([0-9]+)$/si; # untaint
                $oldest_spam = $1 if $row2[1] =~ /^(.+)$/si; # untaint
                $ssize = $1 if $row2[2] =~ /^([0-9]+)$/si; # untaint
            }
            $sth2->finish;
        }

        # Count pending banned files
        my $fcount = 0;
        my $oldest_banned_file = "";
        my $fsize = 0;
        if (!($bypass_banned_checks eq 'Y')) {
            $select = "SELECT COUNT(maia_mail_recipients.mail_id) AS fcount, " .
                             "MIN(maia_mail.received_date) AS oldestbanned, " .
                             "SUM(maia_mail.size) AS fsize " .
                      "FROM maia_mail, maia_mail_recipients " .
                      "WHERE maia_mail.id = maia_mail_recipients.mail_id " .
                      "AND maia_mail_recipients.recipient_id = ? " .
                      "AND maia_mail_recipients.type = 'F'";
            $sth2 = $dbh->prepare($select)
                       or fatal(sprintf("Couldn't prepare query: %s", $dbh->errstr));
            $sth2->execute($user_id)
                or fatal(sprintf("Couldn't execute query: %s", $dbh->errstr));
            if (@row2 = $sth2->fetchrow_array()) {
                $fcount = $1 if $row2[0] =~ /^([0-9]+)$/si; # untaint
                $oldest_banned_file = $1 if $row2[1] =~ /^(.+)$/si; # untaint
                $fsize = $1 if $row2[2] =~ /^([0-9]+)$/si; # untaint
            }
            $sth2->finish;
        }

        # Count pending bad headers
        my $bcount = 0;
        my $oldest_bad_header = "";
        my $bsize = 0;
        if (!($bypass_header_checks eq 'Y')) {
            $select = "SELECT COUNT(maia_mail_recipients.mail_id) AS bcount, " .
                             "MIN(maia_mail.received_date) AS oldestheader, " .
                             "SUM(maia_mail.size) AS bsize " .
                      "FROM maia_mail, maia_mail_recipients " .
                       "WHERE maia_mail.id = maia_mail_recipients.mail_id " .
                      "AND maia_mail_recipients.recipient_id = ? " .
                      "AND maia_mail_recipients.type = 'B'";
            $sth2 = $dbh->prepare($select)
                       or fatal(sprintf("Couldn't prepare query: %s", $dbh->errstr));
            $sth2->execute($user_id)
                or fatal(sprintf("Couldn't execute query: %s", $dbh->errstr));
            if (@row2 = $sth2->fetchrow_array()) {
                $bcount = $1 if $row2[0] =~ /^([0-9]+)$/si; # untaint
                $oldest_bad_header = $1 if $row2[1] =~ /^(.+)$/si; # untaint
                $bsize = $1 if $row2[2] =~ /^([0-9]+)$/si; # untaint
            }
            $sth2->finish;
        }

        my $total_qcount = $vcount + $scount + $fcount + $bcount;
        my $total_qsize = $vsize + $ssize + $fsize + $bsize;

        # Only send out reminder e-mail if the count or size
        # thresholds have been met or exceeded.
        if (($total_qcount >= $reminder_threshold_count) ||
            ($total_qsize >= $reminder_threshold_size)) {

            output(sprintf("Reminding: %s", $user_email));

            my $oldest_virus_time;
            if ($vcount > 0) {
                $oldest_virus =~ /([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/;
                $oldest_virus_time = mktime(int($6), int($5), int($4), int($3), int($2)-1, int($1)-1900);

                # Subtract an hour if DST was in effect at the time
                if ((localtime $oldest_virus_time)[8] > 0) {
                    $oldest_virus_time -= SECS_PER_HOUR;
                }
            }

            my $oldest_spam_time;
            if ($scount > 0) {
                $oldest_spam =~ /([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/;
                $oldest_spam_time = mktime(int($6), int($5), int($4), int($3), int($2)-1, int($1)-1900);

                # Subtract an hour if DST was in effect at the time
                if ((localtime $oldest_spam_time)[8] > 0) {
                    $oldest_spam_time -= SECS_PER_HOUR;
                }
            }

            my $oldest_banned_time;
            if ($fcount > 0) {
                $oldest_banned_file =~ /([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/;
                $oldest_banned_time = mktime(int($6), int($5), int($4), int($3), int($2)-1, int($1)-1900);

                # Subtract an hour if DST was in effect at the time
                if ((localtime $oldest_banned_time)[8] > 0) {
                    $oldest_banned_time -= SECS_PER_HOUR;
                }
            }

            my $oldest_header_time;
            if ($bcount > 0) {
                $oldest_bad_header =~ /([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})/;
                $oldest_header_time = mktime(int($6), int($5), int($4), int($3), int($2)-1, int($1)-1900);

                # Subtract an hour if DST was in effect at the time
                if ((localtime $oldest_header_time)[8] > 0) {
                    $oldest_header_time -= SECS_PER_HOUR;
                }
            }

            # Find the oldest item in the user's quarantine area
            my $oldest_item_time = 0;
            if ($vcount > 0) {
                $oldest_item_time = $oldest_virus_time;
            }
            if ($scount > 0) {
                if ($oldest_item_time > 0) {
                    if ($oldest_spam_time < $oldest_item_time) {
                        $oldest_item_time = $oldest_spam_time;
                    }
                } else {
                    $oldest_item_time = $oldest_spam_time;
                }
            }
            if ($fcount > 0) {
                if ($oldest_item_time > 0) {
                    if ($oldest_banned_time < $oldest_item_time) {
                        $oldest_item_time = $oldest_banned_time;
                    }
                } else {
                    $oldest_item_time = $oldest_banned_time;
                }
            }
            if ($bcount > 0) {
                if ($oldest_item_time > 0) {
                    if ($oldest_header_time < $oldest_item_time) {
                        $oldest_item_time = $oldest_header_time;
                    }
                } else {
                    $oldest_item_time = $oldest_header_time;
                }
            }

           my($oldest_item_expire_time) = $oldest_item_time + $expiry_period * SECS_PER_DAY;

            # Calculate %%OLDESTITEMAGE%%
            my($oldest_item_age) = int((time() - $oldest_item_time) / SECS_PER_DAY + 0.5);

            # Calculate %%OLDESTITEMTTL%%
            my($oldest_item_ttl) = int(($oldest_item_expire_time - time()) / SECS_PER_DAY + 0.5);

            # Perform substitutions in the template
            my($tmp) = $template;
            $tmp =~ s/%%VIRUSCOUNT%%/$vcount/g;
            $tmp =~ s/%%SPAMCOUNT%%/$scount/g;
            $tmp =~ s/%%BANNEDCOUNT%%/$fcount/g;
            $tmp =~ s/%%HEADERCOUNT%%/$bcount/g;
            $tmp =~ s/%%VIRUSSIZE%%/$vsize/g;
            $tmp =~ s/%%SPAMSIZE%%/$ssize/g;
            $tmp =~ s/%%BANNEDSIZE%%/$fsize/g;
            $tmp =~ s/%%HEADERSIZE%%/$bsize/g;
            $tmp =~ s/%%ADMINEMAIL%%/$admin_email/g;
            $tmp =~ s/%%MAIAURL%%/$reminder_login_url/g;
            $tmp =~ s/%%EXPIRYPERIOD%%/$expiry_period/g;
            $tmp =~ s/%%OLDESTITEMAGE%%/$oldest_item_age/g;
            $tmp =~ s/%%OLDESTITEMTTL%%/$oldest_item_ttl/g;
            $tmp =~ s/%%USEREMAIL%%/$user_email/g;
            
     
            # Send out the e-mail
            my($smtp) = Net::SMTP->new($smtp_server, Port => $smtp_port) ;
            fatal("Couldn't connect to SMTP server") unless $smtp;
            $smtp->mail($admin_email) ;
            $smtp->to($user_email) ;
            $smtp->data() ;
            $smtp->datasend($tmp . "\n") ;
            $smtp->dataend() ;
            $smtp->quit() ;
        }
    }
    $sth->finish;

    # Disconnect from the database
    $dbh->disconnect;

    unlink($pid_file);

    # We're done.
    exit;


    # Die, printing a time-stamped error message.
    sub fatal($) {
        my ($msg) = @_;

        output("FATAL ERROR: " . $msg);
        unlink($pid_file);
        exit 1;
    }


    # Write a time-stamped string to stdout for logging purposes.
    sub output($) {
        my ($msg) = @_;
        my ($year, $month, $day, $hour, $minute, $second);
        my ($second, $minute, $hour, $day, $month, $year) = (localtime)[0,1,2,3,4,5];

        printf("%04d-%02d-%02d %02d:%02d:%02d Maia: [%s] %s\n",
               $year+1900, $month+1, $day, $hour, $minute, $second, $script_name, $msg);
    }
