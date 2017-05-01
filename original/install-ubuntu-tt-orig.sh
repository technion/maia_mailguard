# 
# todo - get maia password up front and configure the credentials
#   e.g. - 
#       postfix: domain, hostname, relayhost
#       db: maia pw: maia-grants.  maia.conf, maiad.conf, config.php
#
# assumptions - this is a new machine -
#
#	mysql server is installed, without root password
#	postfix is installed, with default, vanilla config
#	the apache web server is installed and operational
#	the machine has access to the software repositories
#
#  if any of these assumptions are false, some manual cleanup
#  work will have to be done e.g. creating the maia database,
#  editing postfix config files, configuring the web server etc
#

echo 
echo "this is for ubuntu 14.04 LTS (Trusty Tahr)"
echo 
echo -n "<ENTER> to continue or CTRL-C to stop..."
read junk
echo 

# install stage 1 packages

WD=`pwd`

# suppress dialog boxes for package installs
export DEBIAN_FRONTEND=noninteractive

echo "first of all, get up-to-date"
apt-get -y update
apt-get -y upgrade

#
echo "now installing packages.."
apt-get install -y make gcc patch
apt-get install -y curl wget telnet
#
apt-get install -y file
apt-get install -y libdbi-perl
apt-get install -y spamassassin
apt-get install -y libarchive-zip-perl
apt-get install -y libberkeleydb-perl
apt-get install -y libconvert-tnef-perl
apt-get install -y libconvert-uulib-perl
apt-get install -y libdigest-sha-perl
apt-get install -y libcrypt-openssl-rsa-perl
apt-get install -y libdata-uuid-perl
apt-get install -y libdbd-mysql-perl libdbd-pg-perl
apt-get install -y libnet-server-perl
apt-get-install -y libnet-ldap-perl
apt-get install -y libforks-perl
apt-get install -y perl-Net-DNS-Nameserver
apt-get install -y libtext-csv-perl
apt-get install -y libnet-cidr-lite-perl
apt-get install -y libunix-syslog-perl
apt-get install -y razor
apt-get install -y libtemplate-perl
apt-get install -y libmail-dkim-perl
apt-get install -y libencode-detect-perl 
#
#
apt-get install -y clamav 
apt-get install -y clamav-freshclam
apt-get install -y clamav-daemon

#
# add maia user and chown all its files/dirs
#
useradd -d /var/lib/clamav clam
useradd -d /var/lib/maia maia
chmod 755 /var/lib/maia

# create and chown dirs
mkdir -p /var/log/maia
chown -R maia.maia /var/log/maia

#mkdir -p /var/log/clamav
#chown -R clam.clam /var/log/clamav/
#chown -R clamupdate.clam /var/lib/clamav/
#chmod 775 /var/lib/clamav/

mkdir /etc/maia
cp maia.conf.dist /etc/maia/maia.conf
cp maiad.conf.dist /etc/maia/maiad.conf

mkdir -p  /var/lib/maia/tmp
mkdir -p  /var/lib/maia/db
mkdir -p  /var/lib/maia/scripts
mkdir -p  /var/lib/maia/templates
mkdir -p  /var/run/maia
mkdir -p  /var/lock/maia
cp maiad /var/lib/maia/
chown -R maia.maia /var/run/maia
chown -R maia.maia /var/lock/maia
cp -r scripts/* /var/lib/maia/scripts/
cp -r templates/* /var/lib/maia/templates/
chown -R maia.maia /var/lib/maia/db
chown -R maia.maia /var/lib/maia/tmp

#
# web interface
#
mkdir -p /var/www/html/maia
cp -r php/* /var/www/html/maia
echo "done with file copy, starting package install"

# enable services
cp maiad_init_ubuntu /etc/init.d/maiad

# provide config files
#/usr/bin/cp clamd.conf freshclam.conf /etc

# fix clam/maia group memberships
#usermod -G maia clam
#usermod -G clam maia

#
# non-interactive cpan installs
#

apt-get install -y cpanminus

cpanm Digest::SHA1
cpanm IP::Country::Fast
cpanm Razor2::Client::Agent

echo "creating maia database..."
# suppress dialog boxes during mysql install -
apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" mysql-server
#apt-get install -y mysql-server
start mysql
mysqladmin create maia
mysql maia < maia-mysql.sql 
sh maia-grants.sh

echo "stage 1 install complete"

#
# the database should be working at this point.
#
# start maiad 
/etc/init.d/maiad start
# start clamd
/etc/init.d/clamav-daemon start

#
# load the spamassassin rulesets -
#
cp clamav.cf sanesecurity.cf /etc/mail/spamassassin/
/var/lib/maia/scripts/load-sa-rules.pl

echo
echo "installing php modules"
echo
apt-get install -y php5
apt-get install -y php5-mysql
apt-get install -y php5-gd
apt-get install -y php5-xmlrpc
apt-get install -y php-pear
apt-get install -y smarty3
cd /usr/share/php
ln -s smarty3 Smarty
cd $WD


echo
echo "installing pear modules"
echo
pear install DB
pear install MDB2
pear install MDB2#mysql
pear install Mail_mimeDecode
pear install Pager
pear install Net_Socket
pear install Net_SMTP
pear install Auth_SASL
pear install Log
pear channel-discover htmlpurifier.org
pear install hp/HTMLPurifier
pear list


echo
echo "preparing php directory"

# temp bug workaround
for i in /var/www/html/maia/themes/*
do
 mkdir -p ${i}/compiled
done

chmod 775 /var/www/html/maia/themes/*/compiled
chown maia.www-data /var/www/html/maia/themes/*/compiled
cp php/config.php.dist /var/www/html/maia/config.php
mkdir /var/www/cache
chown maia.www-data /var/www/cache
chmod 775 /var/www/cache

echo
echo "reloading http server"

apachectl restart

echo "stage 2 complete"

echo
echo "setting up postfix for maia spam/virus filtering"
echo

cp /etc/postfix/main.cf /etc/postfix/main.cf-save-$$
cp /etc/postfix/master.cf /etc/postfix/master.cf-save-$$

cat master.cf-append >> /etc/postfix/master.cf

postconf -e inet_interfaces=all
postconf -e content_filter=maia:[127.0.0.1]:10024

/etc/init.d/postfix restart

echo
echo	"any site specific MTA setup can be performed now - "
echo

echo 
echo	"before proceeding - " 
echo	"the maia password must be set in 3 places:"
echo	"around line 15 of /etc/maia/maia.conf" 
echo	"around line 194 of /etc/maia/maiad.conf" 
echo	"around line 131 of /var/www/html/maia/config.php"

echo 
echo 	"when this is done..."
echo	"run /var/lib/maia/scripts/configtest.pl" 
echo 
echo 	"If that passes check the web at /maia/admin/config test"
echo	"at http://<your-server>/maia/admin/configtest.php"
echo
echo	"if everything passes, create the initial maia user"
echo	"at http://<your-server>/maia/internal-init.php"
echo

# some useful aliases
cat contrib/bashrc.local.sh >>  /etc/bash.bashrc
