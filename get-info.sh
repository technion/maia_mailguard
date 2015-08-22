#!/usr/bin/env bash
# 
# get configuration paraneters up front 
#
#   parameters of interest:
#	maia db password (default is "password")
#	mysql root password 
#	server hostname
#	server domain name
#	smtp relayhost

#   files subject to modification:
#	/etc/maia/maia.conf
#	/etc/maia/maiad.conf
#	/var/www/html/maia/config.php
#	/etc/postfix/main.cf
#	/etc/postfix/master.cf
#
# assumptions - this is a new machine -
#
#       mysql server is installed, without root password
#       postfix is installed, with default, vanilla config
#       the apache web server is installed and operational
#       the machine has access to the software repositories
#
#  if any of these assumptions are false, some manual cleanup
#  work will have to be done e.g. creating the maia database,
#  editing postfix config files, configuring the web server etc
#

#
# first crack at gathering password choices - 
#
# not yet ready for prime time
#

myroothazpass=0
#myrootwantpass=0
mydbpass=""
mynewdbpass=0
needsmarthost=0

# find out whether to set a new maia db password
echo -n "Do you wish to change the default maia password? (y/N)"
read junk
echo

[ "${junk}X" == "X" ] && junk="n"

if [ $junk == 'y' ] || [ $junk == 'Y' ]; then
  mynewdbpass=1
  echo "Enter the desired password for the maia db and press [ENTER]:"
  read -s mydbpass
  echo
fi

# sort the mysql root password business
echo -n "Is there a mysql root password assigned? (y/N)"
read junk
echo
[ "${junk}X" == "X" ] && junk="n"

if [ $junk == 'y' ] || [ $junk == 'Y' ]; then
  myroothazpass=1
  myrootwantpass=1
  echo "Enter the mysql root password and press [ENTER]:"
  read -s rootmypass
  echo
fi
#elif [ $junk == 'n' ] || [ $junk == 'N' ]; then
#  echo -n "Do you wish to assign a mysql root password at this time? (y/N)"
#  read junk
#  echo
#  [ "${junk}X" == "X" ] && junk="n"
#
#  if [ $junk == 'y' ] || [ $junk == 'Y' ]; then
#    myrootwantpass=1
#    echo "Enter the mysql root password and press [ENTER]:"
#    read -s rootmypass
#    echo
#    myroothazpass=1
#  fi
#fi

if [ $myroothazpass == 0 ]; then
  echo "there is no mysql root password set"
else
  echo "a root password is set for mysql"
fi
echo

#
# get short hostname, domain name, and relayhost
#

shost=`hostname -s`
fqdn=`hostname -f`
domain=`echo $fqdn | sed s/${shost}\.//g`

#echo "this server will use the hostname $shost - correct?"
#echo "if this is correct, hit <ENTER> to continue"
#echo "if not, CTRL-C now, correct the hostname and try again"
#echo
#read junk

#echo "the fully qualified domain name is $fqdn - correct?"
#echo "if this is correct, hit <ENTER> to continue"
#echo "if not, CTRL-C now, correct the FQDN and try again"
#echo
#read junk

echo "does this server require an smtp relayhost/smarthost?"
echo -n "enter relayhost if required, otherwise just press enter:"
read smarthost
[ "${smarthost}X" == "X" ] || needsmarthost=1
echo

#
# review settings - 
#

echo "OK, reviewing settings..."
echo

echo "the short hostname is $shost"
echo
echo "the fully qualified hostname is $fqdn"
echo
echo "the domain seems to be $domain"
echo

if [ $myroothazpass == 1 ]; then
  echo "mysql password for root: $rootmypass"
else 
  echo "mysql will remain without root password"
fi
echo

if [ $mynewdbpass == 1 ]; then
  echo "mysql password for maia: $mydbpass"
else
  echo "default maia db password will be retained"
fi
echo

if [ $needsmarthost == 1 ]; then
  echo "SMTP smarthost: $smarthost"
else
  echo "no SMTP smarthost set"
fi

echo
echo "settings correct? hit <ENTER> to continue, CTRL-C to abort"

#
# final confirmation -
#

read junk
#if [ $mynewdbpass == 1 ] || [ $myroothazpass == 1 ]; then
#  echo "not yet implemented"
#  exit 1
#fi

echo > installer.tmpl
echo "HOST=$shost" >> installer.tmpl
echo "FQDN=$fqdn" >> installer.tmpl
echo "DOMAIN=$domain" >> installer.tmpl

[ $mynewdbpass == 1 ] && echo "MAIAPASS=$mydbpass" >> installer.tmpl
[ $myroothazpass == 1 ] && echo "ROOTPASS=$rootmypass" >> installer.tmpl

[ $needsmarthost == 1 ] && echo "RELAY=$smarthost" >> installer.tmpl

echo "installation parameters:"
cp installer.tmpl cfg_tpl/
cat installer.tmpl
echo

