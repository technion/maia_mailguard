#!/usr/bin/perl -w

package Maia::ProcessQuarantine;

# the user effectively running this script
# (should be the Maia user, e.g. 'maia')
my $script_user = getpwuid($>);

# Don't let the script run as root!
if ($script_user eq 'root') {
	die "This script must not run as the 'root' user; run it as your Maia user instead.\n";
}

my $use_threads = 0;

# Use a Unix domain socket rather than an Inet socket.
# Unix sockets are faster and more secure when all
# processes are running on localhost.  The socket
# file is /var/tmp/perlforks.<pid>
#
# The forks module looks for this setting in the form
# of an environment variable, so we have to set it
# before the module loads.
$ENV{'THREADS_SOCKET_UNIX'} = 1;

# Try to use the forks module first
eval {
   require forks;
   forks->import();
};
if ($@) { # fall back to using threads if available 
	eval {
	   require threads;
	   threads->import();
	   $use_threads = 1;
	};
	if ($@) {
		die ("Perl module 'forks' not installed, and 'threads' support not available.");
    }	
}

use strict;
use warnings;

use DBI;
use Time::HiRes ();
use Getopt::Long;
use Mail::SpamAssassin 3.003000; # SA 3.3.0 or newer
require Mail::SpamAssassin::Message;
Mail::SpamAssassin::Message->import();
use Mail::SpamAssassin::PerMsgLearner;
use Mail::SpamAssassin::Reporter;

# config file variables from /etc/maia/maia.conf
use vars qw( $key_file $default_max_size $pq_log_level $log_dir
             $learning_options $report_options $pid_dir
             $autolearn_ham_threshold $autolearn_spam_threshold
             $default_workers $dsn $username $password
             $autoreport_spam_threshold );

# constants
use constant NWORKERS => 10;
use constant MAXWORKERS => 256;
use constant RAZOR => 1;
use constant PYZOR => 2;
use constant DCC => 4;
use constant SPAMCOP => 8;
use constant ALL => (RAZOR + PYZOR + DCC + SPAMCOP);
use constant LOG_NONE => 0;
use constant LOG_ERROR => 1;
use constant LOG_WARN => 2;
use constant LOG_INFO => 3;
use constant LOG_DEBUG => 4;
use constant LOG_DEBUG_WORKER => 5;
use constant LOG_DEBUG_EMAIL => 6;
use constant LOG_DEBUG_SA_INFO => 7;
use constant LOG_DEBUG_SA_ALL => 8;
use constant LOG_MIN => LOG_NONE;
use constant LOG_MAX => LOG_DEBUG_SA_ALL;
use constant LOG_SPECIAL => 255;

my $type_label = {
   'C' => 'SPAM',       # Confirmed Spam
   'G' => 'HAM',        # Confirmed Ham (i.e. non-spam)
   'S' => 'SPAM-AUTO',  # Autolearn Spam
   'H' => 'HAM-AUTO'    # Autolearn Ham
};

my $log_level_label = {
   'NONE' => LOG_NONE,
   'ERROR' => LOG_ERROR,
   'WARN' => LOG_WARN,
   'INFO' => LOG_INFO,
   'DEBUG' => LOG_DEBUG,
   'DEBUG-WORKER' => LOG_DEBUG_WORKER,
   'DEBUG-EMAIL' => LOG_DEBUG_EMAIL,
   'DEBUG-SA-INFO' => LOG_DEBUG_SA_INFO,
   'DEBUG-SA-ALL' => LOG_DEBUG_SA_ALL,
   'MIN' => LOG_MIN,
   'MAX' => LOG_MAX,
};

# prototypes
sub assemble_email_queues($$$$);
sub connect_to_database($$$$$);
sub decrypt_text($$$);
sub delete_mail($$$$);
sub delete_mail_item($$$);
sub disconnect_from_database($$$);
sub do_exit($);
sub do_learn($$$$$);
sub do_report($$$$$);
sub dump_settings();
sub dump_warnings($);
sub fatal($$);
sub final_summary($$$$$$$$$);
sub get_encryption_key($$);
sub get_log_level_name($);
sub get_log_level_number($$);
sub load_config_file($);
sub lock_script();
sub master_shutdown();
sub output($$$$);
sub prepare_message($$$);
sub process_command_line_input();
sub process_mail($);
sub rate_summary($$$);
sub recalc_stats($$);
sub resync_bayes($$);
sub section_time($$$);
sub start_logging();
sub stop_logging();
sub text_is_encrypted($$);
sub timer_init($$);
sub timer_report($$);
sub unlock_script();
sub update_mail_stats($$$$$);
sub usage();
sub validate_settings($);
sub worker_summary($$$);

my $wid = 0; # Master, main thread/process
my $prefix = 'Master';

# the name of this script, as it should appear in logs
my $script_name;
if ($0 =~ /^(.*\/)*(.+)\.pl$/i) {
   $script_name = $2;
} else {
   $script_name = 'process-quarantine'; # sane default;
}

# read configuration file (/etc/maia/maia.conf)
load_config_file('/etc/maia/maia.conf');

# defaults (overridden by settings in maia.conf)
$default_workers = NWORKERS if !defined($default_workers);
$key_file = undef if !defined($key_file);
$default_max_size = 512*1024 if !defined($default_max_size);
$learning_options = 0 if !defined($learning_options);
$report_options = 0 if !defined($report_options);
$autolearn_ham_threshold = undef if !defined($autolearn_ham_threshold);
$autolearn_spam_threshold = undef if !defined($autolearn_spam_threshold);
$autoreport_spam_threshold = undef if !defined($autoreport_spam_threshold);
my @warnings = ();
my $log_level = (defined($pq_log_level) ? get_log_level_number(\@warnings, $pq_log_level) : LOG_INFO);
$pid_dir = '/var/run/maia' if !defined($pid_dir);
$log_dir = '/var/log/maia' if !defined($log_dir);

my $num_workers = $default_workers;
my $max_size = $default_max_size;
my $learn = $learning_options;
my $report = ($report_options > 0);
my $no_razor = !($report_options & RAZOR);
my $no_pyzor = !($report_options & PYZOR);
my $no_dcc = !($report_options & DCC);
my $no_spamcop = !($report_options & SPAMCOP);
my $spamonly = 0;  # disabled
my $hamonly = 0;   # disabled
my $help = 0;
my $key = get_encryption_key(0, $key_file);
my $dry_run = 0;
my $pid_file = "$pid_dir/process-quarantine.pid";
my $pid = 0;

my $log_file;
if ($log_dir eq '/dev/null') { # no logging
   $log_file = $log_dir;
   $log_level = 0;
} elsif ($log_dir =~ /^console$/i) { # i.e. STDOUT
   $log_file = '-';
} else {
   $log_file = "$log_dir/process-quarantine.log";
}

# Process any switches and parameters supplied on the command-line,
# as these may override settings from the config file.
process_command_line_input();

# Inspect the final state of each setting, now that it has passed
# from default to config to command-line override, and ensure that
# the final state is sane.
validate_settings(\@warnings);

my $report_targets = ALL - ($no_razor * RAZOR) 
                         - ($no_pyzor * PYZOR)
                         - ($no_dcc * DCC)
                         - ($no_spamcop * SPAMCOP);

# Start the logging/console facility for our output.
start_logging();

# Display/log any warnings about settings conflicts, etc.
dump_warnings(\@warnings);

# Make sure there isn't another process-quarantine script
# already running (possibly from an overlapping cron job).
$pid = lock_script();

# Display/log a summary of the settings we're actually using.
dump_settings() if ($log_level >= LOG_INFO);

# Initialize the master timer
my $timer = [ ];
my $master_time_start = Time::HiRes::time;
timer_init($wid, $timer);

# database connection (main thread)
my $dbh = connect_to_database($wid, $timer, $dsn, $username, $password);

# Initialize a task queue for each worker
my @queue = map [ ], 1 .. $num_workers;
my $emails_to_process = assemble_email_queues($wid, $timer, $dbh, \@queue);

# Since we can't share the database handle with the workers, we
# might as well close it now.
disconnect_from_database($wid, $timer, $dbh);

if ($emails_to_process > 0) {

   output(LOG_INFO, $wid, $prefix, sprintf("%d email%s ready for processing, %d worker%s available",
                    $emails_to_process, ($emails_to_process == 1 ? '' : 's'), 
                    $num_workers, ($num_workers == 1 ? '' : 's')));

   # Start only as many workers as we need
   if ($emails_to_process < $num_workers) {
      $num_workers = $emails_to_process;
      output(LOG_INFO, $wid, $prefix, sprintf("Reducing number of workers to %d for efficiency", $num_workers));
   }

   # We've assembled all of the worker queues, now start them all
   my @workers = ();
   for (1 .. $num_workers) {
	  $workers[$_] = threads->new({'context' => 'list', 'exit' => 'thread_only'}, \&process_mail, $queue[$_]);
   }
   section_time($wid, $timer, "all-workers-started");

   my @thread_results = ();
   for (1 .. $num_workers) {
      my @results = $workers[$_]->join();
      $thread_results[$_] = \@results;
   }
	
   my $emails_processed = 0;
   my $total_learned_ham = 0;
   my $total_learned_spam = 0;
   my $total_reported_spam = 0;
   my $total_skipped = 0;
   my $total_time_spent = 0;
	
   ($emails_processed,
    $total_learned_ham,
    $total_learned_spam,
    $total_reported_spam,
    $total_skipped,
    $total_time_spent) = worker_summary($wid, $timer, \@thread_results);	
	
   # All workers have finished and returned by this point
   section_time($wid, $timer, "all-workers-returned");

   final_summary($wid, $timer, $emails_processed, $emails_to_process,
                 $total_learned_ham, $total_learned_spam,
                 $total_reported_spam, $total_skipped, $total_time_spent);

} else {
   output(LOG_INFO, $wid, $prefix, "Nothing to do");
}

output(LOG_INFO, $wid, $prefix, "Shutting down");
master_shutdown();

### END MASTER PROCESS/THREAD ###

############################################################################

# Restart the timer
sub timer_init($$) {
   my ($wid, $time_log) = @_;

   if ($log_level >= LOG_DEBUG) {
      if (!defined $time_log) {
	     fatal($wid, "No time log for worker $wid");
	  }
      @{$time_log} = ();
      section_time($wid, $time_log, 'init');
   }
}


# Add the current time to the timer array with a text label
# to describe the section of the code traversed since the
# previous timestamp.
sub section_time($$$) {
   my($wid, $time_log, $label) = @_;

   if ($log_level >= LOG_DEBUG) {
      push(@{$time_log}, $label, Time::HiRes::time);
   }
}


# Returns an amavisd-style timing report (code courtesy of
# Mark Martinec from amavisd-new).
sub timer_report($$) {
	my($wid, $time_log) = @_;
	
	if ($log_level >= LOG_DEBUG) {
	   my @timing = @{$time_log};
       section_time($wid, $time_log, 'rundown');
       my($notneeded, $t0) = (shift(@timing), shift(@timing));
       my($total) = $t0 <= 0 ? 0 : $timing[$#timing] - $t0;

       if ($total < 0.0000001) { $total = 0.0000001 }
       my(@sections);
       while (@timing) {
          my($section, $t) = (shift(@timing), shift(@timing));
          my($dt) = $t-$t0;
          $dt = 0  if $dt < 0;  # just in case (clock jumps)
          my($dtp) = $dt > $total ? 100 : $dt*100.0/$total;
          push(@sections, sprintf("%s: %.0f (%.0f%%)", $section, $dt*1000, $dtp));
          $t0 = $t;
       }
       return sprintf("TIMING (%s): [total %.0f ms] - %s", 
                      ($wid == 0 ? "Master" : "Worker $wid"), 
                      $total * 1000, join(", ",@sections));
    }
    return '';
}


# Open the log file for unbuffered writes.
sub start_logging() {
	my $log;
	
	$log = open(LOG_FILE, ">> $log_file\0") or die(sprintf("Can't write to log file %s", $log_file));

    # disable buffering, so log entries get written in the proper order
	$log = select(LOG_FILE); $| = 1; select($log);
}


# Close the log file.
sub stop_logging() {
	
	close(LOG_FILE);
	select STDOUT;
}


# Try to write a lock file for this instance of the script, so that only
# one instance can be running at a time.
sub lock_script() {
   my $pid = 0;

   # Check for existing lock file, remove any stale locks
   if (open(PID_FILE, "< $pid_file\0")) {
      while (<PID_FILE>) { chomp; $pid = $_ if /^\d+\z/ }
      close(PID_FILE) or fatal($wid, sprintf("Can't close file %s: %s", $pid_file, $!));
      if (!defined($pid)) {
         output(LOG_ERROR, $wid, $prefix, "Removing invalid lock file");
         unlink($pid_file);
      } elsif (kill 0 => $pid) {
         output(LOG_INFO, $wid, $prefix, sprintf("Another instance [%d] is currently running", $pid));
         master_shutdown();
      } else {
         output(LOG_INFO, $wid, $prefix, sprintf("Removing stale lock file [%d]", $pid));
         unlink($pid_file);
      }
   }

   # Write lock file, store PID
   open(PID_FILE, "> $pid_file\0") or fatal($wid, sprintf("Can't write lock file %s", $pid_file));
   $pid = $$;
   output(LOG_DEBUG, $wid, $prefix, sprintf("Writing lock file [%d]", $pid));
   print PID_FILE $pid;
   close(PID_FILE);

   return $pid;
}


# Remove the lock file.
sub unlock_script() {
	
	if ($pid) {
	   output(LOG_DEBUG, 0, 'Master', sprintf("Removing lock file [%d]", $pid));
	   unlink($pid_file);
    }
}


# Load the maia.conf file and its settings.
sub load_config_file($) {
	my ($config_file) = @_;
	
	unless (my $rv = do $config_file) {
	    fatal($wid, sprintf("Couldn't parse %s: %s", $config_file, $@)) if $@;
	    fatal($wid, sprintf("Couldn't open %s", $config_file)) if (!defined($rv) || !$rv);
	};
}


# Parse any switches and command-line arguments.
sub process_command_line_input() {

	GetOptions("workers=i" => \$num_workers,       # --workers=int or --workers int
	           "max-size=i" => \$max_size,         # --max-size=int or --max-size int
	           "learn" => \$learn,                 # --learn
	           "report" => \$report,               # --report
	           "no-razor" => \$no_razor,           # --no-razor
	           "no-pyzor" => \$no_pyzor,           # --no-pyzor
	           "no-dcc" => \$no_dcc,               # --no-dcc
	           "no-spamcop" => \$no_spamcop,       # --no-spamcop
	           "spam-only" => \$spamonly,          # --spam-only
	           "ham-only" => \$hamonly,            # --ham-only
	           "help" => \$help,                   # --help
	           "log-level=s" => \$log_level,       # --log-level=string or --log-level string
	           "dry-run" => \$dry_run,             # --dry-run
	           "autolearn-ham-threshold=i" => \$autolearn_ham_threshold,
	           "autolearn-spam-threshold=i" => \$autolearn_spam_threshold,
	           "autoreport-spam-threshold=i" => \$autoreport_spam_threshold);
	
    # Display usage information
	if ($help) {
       usage();
       exit;
	}	
}


# Display help info about command-line switches.
sub usage() {
	
   my $help_text = "$script_name\n" .
      "   --ham-only                    : only process ham (non-spam) items\n" .
      "   --spam-only                   : only process spam items\n" .
      "   --learn                       : train the Bayes database\n" .
      "   --report                      : report spam to Razor/DCC/Pyzor/SpamCop\n" .
      "   --no-razor                    : don't report to Razor\n" .
      "   --no-pyzor                    : don't report to Pyzor\n" .
      "   --no-dcc                      : don't report to DCC\n" .
      "   --no-spamcop                  : don't report to SpamCop\n" .
      "   --workers=n                   : number of worker threads to use (default " . NWORKERS . ")\n" .
      "   --max-size=n                  : items larger than n (bytes) will not be processed\n" .
      "   --help                        : display this help text\n" .
      "   --log-level=[level]           : log detail level, one of:\n";

   for (LOG_MIN .. LOG_MAX) {
	  $help_text .= 
      "                                     " .
      $_ . " or '" . lc(get_log_level_name($_)) . "'\n";   	
   }

   $help_text .=
      "   --dry-run                     : don't actually learn/report/delete anything,\n" .
      "                                      just show what would be done\n" .
      "   --autolearn-ham-threshold=n   : learn unconfirmed email with scores <= n as ham\n" .
      "   --autolearn-spam-threshold=n  : learn unconfirmed email with scores >= n as spam\n" .
      "   --autoreport-spam-threshold=n : report unconfirmed email with scores >= n as spam\n";

   print "$help_text\n";
}


# Return the log level as a number, e.g. 'info' -> 3
sub get_log_level_number($$) {
	my ($warnings_list, $level) = @_;
	
	my $level_num = undef;
	if (!defined($level)) {
	    $level_num = LOG_INFO;
	} elsif ($level =~ /^([a-z\-]+)$/i) {  # e.g. none, error, warn, info, debug, etc.
		my $ll = uc($1);
		if (exists($log_level_label->{$ll})) {
			$level_num = int($log_level_label->{$ll});
		} else {
			$level_num = LOG_INFO;
			push (@{$warnings_list}, sprintf("Unknown log level '%s'; using INFO by default.", $ll));
		}
	} elsif ($level =~ /^(\d+)$/) { # e.g. 0, 1, 2, 3, etc.
		$level_num = int($1);
	    if ($level_num > LOG_MAX) {
		   push (@{$warnings_list}, sprintf("Maximum log level is %d (you asked for %d); using %d instead.",
			          LOG_MAX, $level_num, LOG_MAX));
		   $level_num = LOG_MAX;
		}
	} else {
		my $ll = uc($level);
		$level_num = LOG_INFO;
		push (@{$warnings_list}, sprintf("Unknown log level '%s'; using INFO by default.", $ll));
	}
	
	return $level_num;
}


# Look up the symbolic name of a log level, e.g. 3 -> 'info'
sub get_log_level_name($) {
	my ($ll) = @_;
	
    my $level_name = undef;
    while (my ($name, $level) = each(%$log_level_label)) {
	   next if ($name eq 'MIN' || $name eq 'MAX');
	   if (int($level) == $ll) { $level_name = $name; }
	}
	
	return $level_name;
}


# Sanity-check the state of our settings, after defaults, config files,
# and command-line switches have had a chance to modify them.
sub validate_settings($) {
	my ($warnings_list) = @_;
	
	# Sanity-check any supplied arguments
	$log_level = get_log_level_number($warnings_list, $log_level);
	$num_workers = ($num_workers > 0 ? $num_workers : $default_workers);
	if ($num_workers > MAXWORKERS) {
	    $num_workers = MAXWORKERS;
	    push (@{$warnings_list}, "Enforcing maximum limit of " . MAXWORKERS . " concurrent workers.");
	}
	$max_size = ($max_size > 0 ? $max_size : $default_max_size);
	if ($spamonly && $hamonly) {
	    $spamonly = 0;
	    $hamonly = 0;
	    push (@{$warnings_list}, "--spam-only and --ham-only negate each other.");
	}
	if ($hamonly && $report) {
	    $report = 0;
	    push (@{$warnings_list}, "--report disregarded when --ham-only is specified.");
	}
	if ($report && $no_razor && $no_pyzor && $no_dcc && $no_spamcop) {
	    $report = 0;
	    push (@{$warnings_list}, "No one to report to, reporting is disabled.");
	} elsif (!$report && ($no_razor || $no_pyzor || $no_dcc | $no_spamcop)) {
	    $no_razor = 0;
	    $no_pyzor = 0;
	    $no_dcc = 0;
	    $no_spamcop = 0;
	    push (@{$warnings_list}, "--report not specified, reporting is disabled.");
	}
	if (!$learn) {
		if (defined($autolearn_ham_threshold) || defined($autolearn_spam_threshold)) {
			push (@{$warnings_list}, "Learning is disabled, ignoring autolearn threshold settings.");
			$autolearn_ham_threshold = undef;
			$autolearn_spam_threshold = undef;
		}
	} else {
		if (defined($autoreport_spam_threshold) && !defined($autolearn_spam_threshold)) {
			$autolearn_spam_threshold = $autoreport_spam_threshold;
			push (@{$warnings_list}, "Setting implied autolearn-spam-threshold to match autoreport-spam-threshold.");
		}
	}
	if ($report) {
		if (defined($autolearn_spam_threshold) && defined($autoreport_spam_threshold)) {
			if ($autolearn_spam_threshold > $autoreport_spam_threshold) {
				$autoreport_spam_threshold = $autolearn_spam_threshold;
				push (@{$warnings_list}, "Raising autoreport-spam-threshold to match autolearn-spam-threshold.");
			}
		}
	} else {
		if (defined($autoreport_spam_threshold)) {
			push (@{$warnings_list}, "Reporting is disabled, ignoring autoreport threshold settings.");
			$autoreport_spam_threshold = undef;
		}
	}
}


# Output the finalized settings the script will use for this run.
sub dump_settings() {
    my $prefix = 'Master';

	output(LOG_INFO, 0, $prefix, "Starting");

	if ($log_level >= LOG_DEBUG) {
	   output(LOG_DEBUG, 0, $prefix, sprintf("Running as user = %s", $script_user));
	   output(LOG_DEBUG, 0, $prefix, sprintf("Parallel processing model = %s", 
	                ($use_threads ? "threads" : "forks")));
	   output(LOG_DEBUG, 0, $prefix, sprintf("workers = %d", $num_workers));
	   output(LOG_DEBUG, 0, $prefix, sprintf("max-size = %d bytes", $max_size));
	   output(LOG_DEBUG, 0, $prefix, sprintf("learn = %s", ($learn ? 'Yes' : 'No')));
	   if ($learn && $autolearn_ham_threshold) {
	       output(LOG_DEBUG, 0, $prefix, sprintf("autolearn ham <= %s", $autolearn_ham_threshold));
	   }
	   if ($learn && $autolearn_spam_threshold) {
	          output(LOG_DEBUG, 0, $prefix, sprintf("autolearn spam >= %s", $autolearn_spam_threshold));
	   }
	   if ($report && $autoreport_spam_threshold) {
	          output(LOG_DEBUG, 0, $prefix, sprintf("autoreport spam >= %s", $autoreport_spam_threshold));
	   }
	   output(LOG_DEBUG, 0, $prefix, sprintf("report = %s", ($report ? 'Yes' : 'No')));
	   if ($report) {
	       output(LOG_DEBUG, 0, $prefix, sprintf("report to Razor = %s", ($no_razor ? 'No' : 'Yes')));
	       output(LOG_DEBUG, 0, $prefix, sprintf("report to Pyzor = %s", ($no_pyzor ? 'No' : 'Yes')));
	       output(LOG_DEBUG, 0, $prefix, sprintf("report to DCC = %s", ($no_dcc ? 'No' : 'Yes')));
	       output(LOG_DEBUG, 0, $prefix, sprintf("report to SpamCop = %s", ($no_spamcop ? 'No' : 'Yes')));
	   }
	   output(LOG_DEBUG, 0, $prefix, sprintf("spam-only = %s", ($spamonly ? 'Yes' : 'No')));
	   output(LOG_DEBUG, 0, $prefix, sprintf("ham-only = %s", ($hamonly ? 'Yes' : 'No')));
	   output(LOG_DEBUG, 0, $prefix, sprintf("dry-run = %s", ($dry_run ? 'Yes' : 'No')));
	   output(LOG_DEBUG, 0, $prefix, sprintf("log-level = %d (%s)", $log_level, get_log_level_name($log_level)));
	}
}


# Output any warning messages about settings modifications
# to the logging facility.
sub dump_warnings($) {
	my ($warnings_list) = @_;
	
	foreach my $w (@{$warnings_list}) {
		output(LOG_WARN, 0, 'Master', "WARNING: $w");
	}
}


# Establish a connection to the Maia database.
sub connect_to_database($$$$$) {
	my ($wid, $timer, $dsn, $dbuser, $dbpasswd) = @_;
	
	my $dbh;
	if (defined($dsn) && defined($dbuser) && defined($dbpasswd)) {
	    $dbh = DBI->connect($dsn, $dbuser, $dbpasswd)
	        or fatal($wid, "Can't connect to the Maia database (verify \$dsn, \$username, and \$password in maia.conf)");
	} else {
	    fatal($wid, "Can't connect to the Maia database (missing \$dsn, \$username, or \$password in maia.conf)");
	}
	section_time($wid, $timer, 'connect-to-db');
	
	return $dbh;
}


# Disconnect from the Maia database.
sub disconnect_from_database($$$) {
	my ($wid, $timer, $dbh) = @_;
	
	if (defined($dbh)) {
		$dbh->disconnect();
		$dbh = undef;
	}
    section_time($wid, $timer, 'disconnect-from-db');
}


# Create a list of all emails ready for processing, and
# divide this list among the available workers so that
# each worker has its own queue of emails to process.
sub assemble_email_queues($$$$) {
	my ($wid, $timer, $dbh, $queue) = @_;

    if (!defined($dbh)) {
	   fatal($wid, "No database connection!");
    }

    #   List any confirmed spam (C), confirmed ham (G),
    #   autolearnable spam (S), and autolearnable ham (H),
    #   filtered by the $spamonly and $hamonly flags.
    my $query = <<EOQ;
SELECT maia_mail.id, 
       maia_mail_recipients.recipient_id, 
       maia_mail_recipients.type,
       maia_mail.size,
       maia_mail.score,
       maia_mail.autolearn_status
FROM   maia_mail, maia_mail_recipients
WHERE  maia_mail.id = maia_mail_recipients.mail_id
EOQ
	$query .= " AND (";
	if ($spamonly) {
		$query .= "maia_mail_recipients.type = 'C'";
		if (defined $autoreport_spam_threshold && $autoreport_spam_threshold =~ /^(\-?\d*(\.\d+)?)$/) {
			$query .= " OR maia_mail.score >= $autoreport_spam_threshold";
		}
		if (defined $autolearn_spam_threshold && $autolearn_spam_threshold =~ /^(\-?\d*(\.\d+)?)$/) {
			$query .= " OR maia_mail.score >= $autolearn_spam_threshold";
		}
	} elsif ($hamonly) {
		$query .= "maia_mail_recipients.type = 'G'";
		if (defined $autolearn_ham_threshold && $autolearn_ham_threshold =~ /^(\-?\d*(\.\d+)?)$/) {
			$query .= " OR maia_mail.score <= $autolearn_ham_threshold";
		}
	} else {
		$query .= "maia_mail_recipients.type = 'C' OR maia_mail_recipients.type = 'G'";
		if (defined $autoreport_spam_threshold && $autoreport_spam_threshold =~ /^(\-?\d*(\.\d+)?)$/) {
			$query .= " OR maia_mail.score >= $autoreport_spam_threshold";
		}
		if (defined $autolearn_spam_threshold && $autolearn_spam_threshold =~ /^(\-?\d*(\.\d+)?)$/) {
			$query .= " OR maia_mail.score >= $autolearn_spam_threshold";
		}
		if (defined $autolearn_ham_threshold && $autolearn_ham_threshold =~ /^(\-?\d*(\.\d+)?)$/) {
			$query .= " OR maia_mail.score <= $autolearn_ham_threshold";
		}		
	}
	$query .= ");";

	my $sth = $dbh->prepare($query)
	   or fatal($wid, "Prepare failed: " . $dbh->errstr);
	section_time($wid, $timer, 'assemble-queues-db-prepare');

	$sth->execute()
	   or fatal($wid, "Execute failed: " . $dbh->errstr);
	section_time($wid, $timer, 'assemble-queues-db-execute');

	# Assign tasks to workers in an alternating sequence
	# to distribute the load as evenly as possible.
	my $i = 1;
	my $emails_to_process = 0;
	while (my @row = $sth->fetchrow_array()) {
		my $mailid = $row[0];
		my $recipid = $row[1];
		my $type = $row[2];
		my $size = $row[3];
		my $score = $row[4];
		my $autolearn_status = $row[5];
		my $task = { 
			         mailid => $mailid,              # maia_mail.id 
			         recipid => $recipid,            # maia_mail_recipients.recipient_id
			         type => $type,                  # maia_mail_recipients.type
			         size => $size,                  # maia_mail.size
			         score => $score,                # maia_mail.score
			         autolearn => $autolearn_status, # maia_mail.autolearn_status
		};
	    push (@{$queue[$i]}, $task);
	    $emails_to_process++;
		$i++; if ($i > $num_workers) { $i = 1; }
	}
	$sth->finish;
	section_time($wid, $timer, 'master-db-fetch-all');
	
	return $emails_to_process;
}


# A more graceful version of exit()
sub do_exit($) {
	my ($status) = @_;
	
    unlock_script();
    stop_logging();

	# Trap an annoying SIGSEGV that occurs on exit()
	# when the forks module tries to free memory twice.
	$SIG{SEGV} = sub { exit $status; };

	exit $status;
}



# Quit gracefully.
sub master_shutdown() {
	
   do_exit(0);
}


# Die (gracefully), printing a time-stamped error message.
sub fatal($$) {
    my ($wid, $msg) = @_;

    my $formatted_msg = sprintf("(%s): %s",
                        ($wid == 0 ? "Master" : "Worker $wid"),
                        $msg);

    # write it to STDERR before anything else can go wrong
    print STDERR $formatted_msg;

    # use LOG_SPECIAL to make sure it always gets logged
    output(LOG_SPECIAL, $wid, 'FATAL ERROR', $formatted_msg);

    do_exit(1);
}


# Write a time-stamped string to the log file.
sub output($$$$) {
    my ($min_log_level, $wid, $prefix, $msg) = @_;

    if ($min_log_level == LOG_SPECIAL || $log_level >= $min_log_level) {
	   my ($second, $minute, $hour, $day, $month, $year) = (localtime)[0,1,2,3,4,5];
       printf LOG_FILE ("%04d-%02d-%02d %02d:%02d:%02d %s%s %s\n",
              $year+1900, $month+1, $day, $hour, $minute, $second, 
              ($log_level >= LOG_DEBUG ? "[$$]" : ''),
              (($prefix && $log_level >= LOG_DEBUG_WORKER) ? "[$prefix]" : ''),
              $msg);
    }
}


# Read the encryption key from a file.
sub get_encryption_key($$) {
    my ($wid, $key_file) = @_;
    my ($key);

    if (!defined $key_file) {
        return undef;
    }

    use IO::File;
    my $fh = new IO::File;

    $key_file = $1 if $key_file =~ /^(.+)$/si; # untaint

    # Key file exists, read key from file
    if ($fh->open("<" . $key_file)) {
        sysread($fh, $key, 56);
        $fh->close;
        return $key;
    } else {
        fatal($wid, sprintf("Can't open encryption key file %s", $key_file));
    }
}


# Returns true (1) if the text is encrypted, false (0) otherwise.
sub text_is_encrypted($$) {
    my ($wid, $text) = @_;

    return ($text =~ /^RandomIV/);
}


sub decrypt_text($$$) {
	my ($wid, $key, $ciphertext) = @_;
    my ($cipher);

    my $prefix = "Worker $wid";

    require Crypt::CBC;

    $key = $1 if $key =~ /^([^\0]{56})$/si; # untaint
    if (text_is_encrypted($wid, $ciphertext)) {
        $cipher = Crypt::CBC->new( {'key' => $key,
                                    'cipher' => 'Blowfish',
                                    'regenerate_key' => 0,
                                    'padding' => 'null',
                                    'prepend_iv' => 1,
                                    'header' => 'randomiv'
                                 } );

        output(LOG_DEBUG_EMAIL, $wid, $prefix, "Email is encrypted.");
        return $cipher->decrypt($ciphertext);
    } else {
        output(LOG_DEBUG_EMAIL, $wid, $prefix, "Email is not encrypted.");
        return $ciphertext;
    }
}


# Delete one specific mail item and all references to it.
sub delete_mail_item($$$) {
	my($wid, $dbh, $mail_id) = @_;
	my($sth, $delete);

	$mail_id = $1 if $mail_id =~ /^([0-9]*)$/si; # untaint

    if ($dry_run) {
	   my $prefix = "Worker $wid";
	
	   output(LOG_DEBUG_EMAIL, $wid, $prefix, sprintf("DRY RUN: Pretending to delete email %d", $mail_id));
	   return;
    }

	# Delete the mail item itself
	$delete = "DELETE FROM maia_mail WHERE id = ?";
	$sth = $dbh->prepare($delete)
	            or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
	$sth->execute($mail_id)
	    or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));

	# Delete all recipient references to the mail item
	$delete = "DELETE FROM maia_mail_recipients WHERE mail_id = ?";
	$sth = $dbh->prepare($delete)
	            or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
	$sth->execute($mail_id)
	    or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));

	# Delete any virus references to the mail item
	$delete = "DELETE FROM maia_viruses_detected WHERE mail_id = ?";
	$sth = $dbh->prepare($delete)
	            or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
	$sth->execute($mail_id)
	    or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));

	# Delete any SpamAssassin rule references to the mail item
	$delete = "DELETE FROM maia_sa_rules_triggered WHERE mail_id = ?";
	$sth = $dbh->prepare($delete)
	             or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
	$sth->execute($mail_id)
	    or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));

	# Delete any banned file attachment references to the mail item
	$delete = "DELETE FROM maia_banned_attachments_found WHERE mail_id = ?";
	$sth = $dbh->prepare($delete)
	            or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
	$sth->execute($mail_id)
	    or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));
}


# Delete mail references for recipients who agree that
# the mail item is [spam|ham].  Remove the mail item
# itself, if no other recipients reference it.
sub delete_mail($$$$) {
	my($wid, $dbh, $mail_id, $type) = @_;
    my($sth, $sth2, $delete, $select);

    my $prefix = "Worker $wid";

    $mail_id = $1 if $mail_id =~ /^([0-9]*)$/si; # untaint

    if ($dry_run) {
	   output(LOG_DEBUG_EMAIL, $wid, $prefix, sprintf("DRY RUN: Pretending to delete references to email %d", $mail_id));
	   return;
    }

    # Delete mail references for all recipients who agree
    # that the mail item is [spam|ham].
    $delete = "DELETE FROM maia_mail_recipients " .
              "WHERE mail_id = ? AND type = ?";
    $sth = $dbh->prepare($delete)
               or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
    $sth->execute($mail_id, $type)
        or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));
    output(LOG_DEBUG_EMAIL, $wid, $prefix, sprintf("Deleted spam/non-spam recipient references to mail item %d", $mail_id));

    # See if any other mail references exist for this mail
    # item, i.e. any other recipients.
    $select = "SELECT recipient_id FROM maia_mail_recipients " .
              "WHERE mail_id = ?";
    $sth = $dbh->prepare($select)
               or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
    $sth->execute($mail_id)
        or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));

    # If no other recipients exist for this mail item,
    # delete the mail item itself.
    if (!$sth->fetchrow_array()) {
        delete_mail_item($wid, $dbh, $mail_id);
        output(LOG_DEBUG_EMAIL, $wid, $prefix, sprintf("Deleted mail item %d", $mail_id));
    } else {
        output(LOG_DEBUG_EMAIL, $wid, $prefix, sprintf("Retaining mail item %d, since it still has recipient references.", $mail_id));
    }
    $sth->finish;
}


# Resynchronize the Bayes database after all learning
# operations have been completed.
sub resync_bayes($$) {
	my ($wid, $timer) = @_;

    if ($dry_run) {
	   my $prefix = 'Master';
	
	   output(LOG_DEBUG, $wid, $prefix, "DRY RUN: Pretending to resynchronize the Bayes database");
	   return;
    }

    my $sa_debug = undef;
	$sa_debug = 'info' if ($log_level == LOG_DEBUG_SA_INFO);
	$sa_debug = 'all' if ($log_level == LOG_DEBUG_SA_ALL);
	my $sa = Mail::SpamAssassin->new({ debug => $sa_debug } );
    section_time($wid, $timer, 'resync-sa-init');

	my $sa_verbose = ($log_level == LOG_DEBUG_SA_ALL ? 1 : 0);
    $sa->rebuild_learner_caches({ verbose => $sa_verbose });
    $sa->finish_learner();
    section_time($wid, $timer, 'resync-bayes');
	
    $sa->finish;
    section_time($wid, $timer, 'resync-sa-finish');	
}


# Puts the contents of an email into a
# SpamAssassin message structure for Bayes
# training and/or reporting.
sub prepare_message($$$) {
	my ($wid, $timer, $msg) = @_;

	my @body = split (/^/m, $msg);
    my $dataref = \@body;
    my $mail_obj = Mail::SpamAssassin::Message->new({message => $dataref, parse_now => 0});
    section_time($wid, $timer, 'prepare-message');

    return $mail_obj;
}


# Train the Bayes engine explicitly with the contents of
# a single e-mail, forcing it to recognize the mail as
# spam or ham.
sub do_learn($$$$$) {
	my($wid, $timer, $sa, $msg, $isspam) = @_;
    my($learner, $learned);

    if ($dry_run) {
	
	   my $prefix = "Worker $wid";
	   output(LOG_DEBUG_WORKER, $wid, $prefix, sprintf("DRY RUN: Pretending to learn email as %s", ($isspam ? 'SPAM' : 'HAM')));
	   $learned = 1;
	
    } else {

       if (!defined($sa)) {
	      fatal($wid, "SpamAssassin object does not exist!");
       }
       my $mail_obj = prepare_message($wid, $timer, $msg);
	   fatal($wid, "Failed to prepare message") if (!$mail_obj);
       $learner = $sa->learn($mail_obj, undef, $isspam, 0);
       $learned = $learner->did_learn();
       $learner->finish();
       $mail_obj->finish();

    }

    section_time($wid, $timer, 'train-bayes');
	return $learned;
}


# Report spam to Vipul's Razor, the DCC, and/or Pyzor,
# and optionally train the Bayes engine in the process
# (recognizing the mail item as spam).
sub do_report($$$$$) {
	my($wid, $timer, $sa, $msg, $autospam) = @_;
    my($reported);
    my $no_razor = !($report_targets & RAZOR);
    my $no_pyzor = !($report_targets & PYZOR);
    my $no_dcc = !($report_targets & DCC);
    my $no_spamcop = !($report_targets & SPAMCOP);

    if ($dry_run) {
	
	   my $prefix = "Worker $wid";
	   my $text = sprintf("DRY RUN: Pretending to %sreport spam to ",
	                       ($learn ? 'learn and ' : ''));
	   output(LOG_DEBUG_WORKER, $wid, $prefix, $text . 'Razor') if !$no_razor;
	   output(LOG_DEBUG_WORKER, $wid, $prefix, $text . 'Pyzor') if !$no_pyzor;
	   output(LOG_DEBUG_WORKER, $wid, $prefix, $text . 'DCC') if !$no_dcc;
	   output(LOG_DEBUG_WORKER, $wid, $prefix, $text . 'SpamCop') if !$no_spamcop;
	   $reported = 1;
	
    } else {

       if (!defined($sa)) {
	      fatal($wid, "SpamAssassin object does not exist!");
       }
       my $mail_obj = prepare_message($wid, $timer, $msg);
	   fatal($wid, "Failed to prepare message") if (!$mail_obj);

       # Only perform Bayes training if learning is enabled
       # and the spam was not already correctly auto-learned
       $sa->{conf}->{bayes_learn_during_report} = ($learn && !$autospam);
       $reported = $sa->report_as_spam($mail_obj, 
                    {
                      dont_report_to_razor => $no_razor,
                      dont_report_to_pyzor => $no_pyzor,
                      dont_report_to_dcc => $no_dcc,
                      dont_report_to_spamcop => $no_spamcop
                    }
       );
       $mail_obj->finish();

    }

    section_time($wid, $timer, 'send-report');
    return $reported;
}


# Summarize the processing rate (emails/second) of either
# an individual worker or the master process.
sub rate_summary($$$) {
	my ($wid, $start_time, $email_count) = @_;
    my $finish_time = Time::HiRes::time;

    my $total_time = $finish_time - $start_time;
    return sprintf("%sProcessed %d email%s in %d seconds (%4.2f emails/sec)",
            ($log_level >= LOG_DEBUG ? ($wid == 0 ? 'RATE (Master): ' : "RATE (Worker $wid)") : ''),
            $email_count,
            ($email_count == 1 ? '' : 's'),
            $total_time,
            $email_count / $total_time);
}


# overall performance summary of this processing run, 
# including final cleanup before termination.
sub final_summary($$$$$$$$$) {
	my ($wid, $timer, $emails_processed, $emails_to_process,
		$total_learned_ham, $total_learned_spam,
		$total_reported_spam, $total_skipped, $total_time_spent) = @_;
		
	my $prefix = 'Master';

    output(LOG_INFO, $wid, $prefix, sprintf("%d of %d email%s processed (%d%%) : %d learned ham, %d learned spam, %d reported spam, %d skipped", 
           $emails_processed, $emails_to_process,
           ($emails_to_process == 1 ? '' : 's'), 
           ($emails_processed == 0 ? 0 : int(100 * $emails_processed / $emails_to_process + 0.5)),
           $total_learned_ham, $total_learned_spam, $total_reported_spam, $total_skipped));
    section_time($wid, $timer, "debug-summary");

    # If any learning has taken place, resynchronize the
    # Bayes database.
    if ($total_learned_ham + $total_learned_spam > 0) {
       resync_bayes($wid, $timer);
    }

    if ($emails_processed > 0) {
	   recalc_stats($wid, $timer);
    }

    output(LOG_DEBUG, $wid, $prefix, timer_report($wid, $timer));
    output(LOG_INFO, $wid, $prefix, rate_summary($wid, $master_time_start, $emails_processed));
}


# performance summary of one worker thread.
sub worker_summary($$$) {
	my ($wid, $timer, $results_array) = @_;
	my $emails_processed = 0;
	my $total_learned_ham = 0;
	my $total_learned_spam = 0;
	my $total_reported_spam = 0;
	my $total_skipped = 0;
	my $total_time_spent = 0;
	my $completed = 0;
	my $learned_ham = 0;
	my $learned_spam = 0;
	my $reported_spam = 0;
	my $skipped = 0;
	my $time_start;
	my $time_spent = 0;
	my $worker_timer;
	my @results = @{$results_array};
	
	my $prefix = 'Master';

    for (1 .. $num_workers) {
	    $completed = $results[$_][0];
	    $learned_ham = $results[$_][1];
	    $learned_spam = $results[$_][2];
	    $reported_spam = $results[$_][3];
	    $skipped = $results[$_][4];
	    $time_start = $results[$_][5];
	    $worker_timer = $results[$_][6];
	
        output(LOG_DEBUG_WORKER, $wid, $prefix, sprintf("Worker %d processed %d email%s (%d learned ham, %d learned spam, %d reported spam, %d skipped)", 
		                         $_, $completed, ($completed == 1 ? '' : 's'), 
		                         $learned_ham, $learned_spam, $reported_spam, $skipped));

        output(LOG_DEBUG_WORKER, $wid, $prefix, timer_report($_, $worker_timer));
		output(LOG_DEBUG_WORKER, $wid, $prefix, rate_summary($_, $time_start, $completed));
		
		$emails_processed += $completed;
		$total_learned_ham += $learned_ham;
		$total_learned_spam += $learned_spam;
		$total_reported_spam += $reported_spam;
		$total_skipped += $skipped;
		$total_time_spent += (Time::HiRes::time - $time_start);	
     }
     section_time($wid, $timer, "worker-summary");

     return ($emails_processed, $total_learned_ham, $total_learned_spam,
	         $total_reported_spam, $total_skipped, $total_time_spent);
}


# Recalculate the suspected spam OR suspected ham statistics
# for a specific user.
sub update_mail_stats($$$$$) {
    my($wid, $timer, $dbh, $user_id, $type) = @_;
    my($sth, $sth2, $sth3, $sth4, @row, $select, $update, $insert);
    my($token);

    if ($dry_run) {
	   output(LOG_DEBUG, $wid, 'Master', "DRY RUN: Pretending to update mail stats");
	   return;
    }

    if ($type eq "suspected_spam") {
        $token = "S";
    } elsif ($type eq "suspected_ham") {
        $token = "H";
    } else {
        $token = "";
    }

    # Calculate current aggregates for items of the specified type
    $select = "SELECT MIN(received_date) AS mindate, " .
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
              "AND maia_mail_recipients.type = ? " .
              "AND maia_mail_recipients.recipient_id = ? ";
    $sth = $dbh->prepare($select)
                  or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
    $sth->execute($token, $user_id)
        or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));
    my($mindate, $maxdate, $minscore, $maxscore, $totalscore, $minsize, $maxsize, $totalsize, $items);
    if (($mindate, $maxdate, $minscore, $maxscore, $totalscore, $minsize, $maxsize, $totalsize, $items) = $sth->fetchrow()) {
        $select = "SELECT user_id FROM maia_stats WHERE user_id = ?";
        $sth2 = $dbh->prepare($select)
                    or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
        $sth2->execute($user_id)
             or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));

        # User already has a stats record, update it.
        if ($user_id == $sth2->fetchrow()) {
            $update = "UPDATE maia_stats SET oldest_" .   $type . "_date = ?, " .
                                            "newest_" .   $type . "_date = ?, " .
                                            "lowest_" .   $type . "_score = ?, " .
                                            "highest_" .  $type . "_score = ?, " .
                                            "total_" .    $type . "_score = ?, " .
                                            "smallest_" . $type . "_size = ?, " .
                                            "largest_" .  $type . "_size = ?, " .
                                            "total_" .    $type . "_size = ?, " .
                                            "total_" .    $type . "_items = ? " .
                      "WHERE user_id = ?";
                                              
           $sth3 = $dbh->prepare($update)
                       or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
           $sth3->execute($mindate,
                          $maxdate,
                          (defined($minscore) ? $minscore : 0),
                          (defined($maxscore) ? $maxscore : 0),
                          (defined($totalscore) ? $totalscore : 0),
                          (defined($minsize) ? $minsize : 0),
                          (defined($maxsize) ? $maxsize : 0),
                          (defined($totalsize) ? $totalsize : 0),
                          (defined($items) ? $items : 0),
                          $user_id)
                or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));
           $sth3->finish;

        # User doesn't have a stats record yet, create a new one for him.
        } else {
            $insert = "INSERT INTO maia_stats (oldest_" .   $type . "_date, " .
                                              "newest_" .   $type . "_date, " .
                                              "lowest_" .   $type . "_score, " .
                                              "highest_" .  $type . "_score, " .
                                              "total_" .    $type . "_score, " .
                                              "smallest_" . $type . "_size, " .
                                              "largest_" .  $type . "_size, " .
                                              "total_" .    $type . "_size, " .
                                              "total_" .    $type . "_items, " .
                                              "user_id) " .
                      "VALUES (?,?,?,?,?,?,?,?,?,?)";
            $sth4 = $dbh->prepare($insert)
                        or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
            $sth4->execute($mindate,
                           $maxdate,
                           (defined($minscore) ? $minscore : 0),
                           (defined($maxscore) ? $maxscore : 0),
                           (defined($totalscore) ? $totalscore : 0),
                           (defined($minsize) ? $minsize : 0),
                           (defined($maxsize) ? $maxsize : 0),
                           (defined($totalsize) ? $totalsize : 0),
                           (defined($items) ? $items : 0),
                           $user_id)
                or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));
            $sth4->finish;
        }
        $sth2->finish;
    }
    $sth->finish;
}


# Recalculate the suspected spam and suspected ham statistics
# for all users.
sub recalc_stats($$) {
    my($wid, $timer) = @_;
    my($user_id);

    my $prefix = 'Master';

    if ($dry_run) {
	   output(LOG_DEBUG, $wid, $prefix, "DRY RUN: Pretending to recalculate statistics");
    } else {

	   output(LOG_DEBUG, $wid, $prefix, "Recalculating statistics");

	   my $dbh = connect_to_database($wid, $timer, $dsn, $username, $password);

       my $select = "SELECT maia_users.id FROM maia_users";
       my $sth = $dbh->prepare($select)
                     or fatal($wid, sprintf("Couldn't prepare query: %s", $dbh->errstr));
       $sth->execute()
           or fatal($wid, sprintf("Couldn't execute query: %s", $dbh->errstr));
       while (my @row = $sth->fetchrow_array()) {
           $user_id = $1 if $row[0] =~ /^([0-9]+[0-9]*)$/si; # untaint
           update_mail_stats($wid, $timer, $dbh, $user_id, "suspected_spam");
           update_mail_stats($wid, $timer, $dbh, $user_id, "suspected_ham");
       }
       $sth->finish;

       section_time($wid, $timer, 'recalc-stats');  
	   disconnect_from_database($wid, $timer, $dbh);
    }
}


# The worker thread
sub process_mail($) {
    my ($queue) = @_;

    my $wid = threads->tid; # Thread ID

	my $prefix = "Worker $wid";
	
    output(LOG_DEBUG_WORKER, $wid, $prefix, "Starting");

	my $completed = 0;
	my $learned_ham = 0;
	my $learned_spam = 0;
	my $reported_spam = 0;
	my $skipped = 0;
	my $timer = [ ]; # timing log for this worker
	my $worker_time_start = Time::HiRes::time;
	timer_init($wid, $timer);
	
	# Initialize a new SpamAssassin object for this worker
	my $sa_debug = undef;
	$sa_debug = 'info' if ($log_level == LOG_DEBUG_SA_INFO);
	$sa_debug = 'all' if ($log_level == LOG_DEBUG_SA_ALL);
	my $sa = Mail::SpamAssassin->new({ debug => $sa_debug });
    $sa->init_learner({ caller_will_untie => 1, 
	                    force_expire => 0,
	                    learn_to_journal => 0,
	                    wait_for_lock => 0,
	                    no_relearn => 0 });
	section_time($wid, $timer, 'worker-sa-init');
	
	# Establish our own database connection for this worker
	my $dbh = connect_to_database($wid, $timer, $dsn, $username, $password);

	my $query = <<EOQ;
SELECT contents
FROM maia_mail
WHERE maia_mail.id = ?
EOQ
    my $sth = $dbh->prepare($query)
       or fatal($wid, "Prepare failed: " . $dbh->errstr);

    section_time($wid, $timer, 'worker-db-init');

    # Emails in each worker's queue are processed serially
    foreach my $email (@$queue) {
		my $mailid = $email->{mailid};
		my $recipid = $email->{recipid};
		my $type = $email->{type};
		my $size = $email->{size};
		my $score = $email->{score};
		my $autolearn_status = $email->{autolearn};

        # Four possible mail types at this point:
        #
        # 'C' : Confirmed Spam
        # 'G' : Confirmed Ham (non-spam)
        # 'S' : High-scoring Spam to be Auto-Learned
        # 'H' : Low-scoring Ham to be Auto-Learned
	    my $isspam = ($type =~ /[CS]/i ? 1 : 0);
	    my $isauto = ($type =~ /[HS]/i ? 1 : 0);
	    my $autoham = ($autolearn_status =~ /^ham$/i ? 1 : 0);
	    my $autospam = ($autolearn_status =~ /^spam$/i ? 1 : 0);

        if ($log_level >= LOG_DEBUG) {
	        output(LOG_DEBUG, $wid, $prefix, sprintf("Processing email %d, type %s, score %s, autolearn = '%s'", $mailid, 
	               $type_label->{$type}, (defined($score) ? sprintf("%6.3f", $score) : '-'), $autolearn_status));
        } else {
	        output(LOG_INFO, $wid, $prefix, sprintf("Processing email %d, type %s", $mailid, 
	               $type_label->{$type}));
        }

        # Don't waste resources on items too big for SpamAssassin to handle
		if ($size > $max_size) {
		
	       output(LOG_DEBUG, $wid, $prefix, sprintf("Skipping email %d (too big: %d > %d)",
	              $mailid, $size, $max_size));
	       $skipped++;

        # No need to bother SpamAssassin if neither learning nor reporting is desired
        } elsif (!$learn && !$report) {
	
           output(LOG_DEBUG, $wid, $prefix, sprintf("Skipping email %d (learning and reporting are both disabled)"));
           $skipped++;

        # Don't ask SpamAssassin to re-learn something it has already correctly auto-learned,
        # unless it's spam and we want to report it.
	    } elsif ($learn && ((!$isspam && $autoham) || ($isspam && $autospam && !$report))) {

		   output(LOG_DEBUG, $wid, $prefix, sprintf("Skipping email %d (already correctly auto-learned)",
		          $mailid));
		   $skipped++;

        # Everything else needs SpamAssassin's attention
        } else {
		
		   $sth->execute($mailid)
			   or fatal($wid, "Execute failed: " . $dbh->errstr);

		   my $contents = "";
		   if (my @row = $sth->fetchrow_array()) {
				$contents = $row[0];
		   }

	       if (defined $key) {
		      $contents = decrypt_text($wid, $key, $contents);
	       }

	       if ($learn && !$report) { # no reporting, so learn all whether confirmed or not

		      if (do_learn($wid, $timer, $sa, $contents, $isspam)) {
			     ($isspam ? $learned_spam++ : $learned_ham++);
			     output(LOG_DEBUG, $wid, $prefix, sprintf("Learned mail item %d as %s%s", $mailid,
			                                     ($isspam ? "spam" : "ham"),
			                                     ($isauto ? " (auto)" : "")));
 		      } else {
	             output(LOG_DEBUG, $wid, $prefix, sprintf("Skipping email %d (SpamAssassin)", $mailid));
	             $skipped++;
	          }
		
	       } elsif ($report && !$learn) { # only report spam

              if ($type eq 'C' || 
                  ($type eq 'S' && defined($autoreport_spam_threshold) && $score >= $autoreport_spam_threshold)) {

		         if (do_report($wid, $timer, $sa, $contents, $autospam)) {
			        $reported_spam++;
                    output(LOG_DEBUG, $wid, $prefix, sprintf("Reported mail item %d", $mailid));
 		         }	else {
	                output(LOG_DEBUG, $wid, $prefix, sprintf("Skipping email %d (SpamAssassin)", $mailid));
	                $skipped++;
		         }
		      }
		
	       } elsif ($report && $learn) {

              if ($type eq 'C' || 
                  ($type eq 'S' && defined($autoreport_spam_threshold) && $score >= $autoreport_spam_threshold)) {

		         if (do_report($wid, $timer, $sa, $contents, $autospam)) {
			        $reported_spam++;
                    $learned_spam++;
                    output(LOG_DEBUG, $wid, $prefix, sprintf("Learned mail item %d as spam and reported it", $mailid));
		         } else {
	                output(LOG_DEBUG, $wid, $prefix, sprintf("Skipping email %d (SpamAssassin)", $mailid));
	                $skipped++;
	             }

		      } else { # just learn, don't report

			     if (do_learn($wid, $timer, $sa, $contents, $isspam)) {
			        ($isspam ? $learned_spam++ : $learned_ham++);
                    output(LOG_DEBUG, $wid, $prefix, sprintf("Learned email %d as %s%s", $mailid,
                                                  ($isspam ? "spam" : "ham"),
                                                  ($isauto ? " (auto)" : "")));
                 } else {
	                output(LOG_DEBUG, $wid, $prefix, sprintf("Skipping email %d (SpamAssassin)", $mailid));
	                $skipped++;
                 }

		      }

	       }
	
	    }
	
        # Remove all recipient references to the mail item
        # (and the item itself, if no other recipients remain)
	    delete_mail($wid, $dbh, $mailid, $type);
	    section_time($wid, $timer, 'delete-mail');
		
	    $completed++;
	
    }
	$sth->finish;
	disconnect_from_database($wid, $timer, $dbh);
	
	$sa->finish_learner();
	$sa->finish;
	section_time($wid, $timer, 'worker-sa-finish');
	
    output(LOG_DEBUG_WORKER, $wid, $prefix, "Shutting down");
	return ($completed, $learned_ham, $learned_spam, $reported_spam, 
            $skipped, $worker_time_start, $timer);

	### END OF WORKER THREAD ###
}

1; # Maia::ProcessQuarantine
