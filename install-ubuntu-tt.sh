# testing - call info gathering script, then use params for install 

echo 
echo "this is for ubuntu 14.04 LTS (Trusty Tahr)"
echo 
echo -n "<ENTER> to continue or CTRL-C to stop..."
read junk
echo 

# get the info, write parames to a file
./get-info.sh

# find out what we need to change
./process-changes.sh

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

mkdir -p /etc/maia
cp maia.conf maiad.conf /etc/maia/

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
cp config.php /var/www/html/maia/
mkdir /var/www/cache
chown maia.www-data /var/www/cache
chmod 775 /var/www/cache

echo
echo "reloading http server"

apachectl restart

echo "stage 2 complete"

# call postfix setup script
./postfix-setup.sh

/etc/init.d/postfix restart

host=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`

echo
echo	"any other site specific MTA configuration can be applied now - "
echo

echo	"at this point, a good sanity check would be to run"
echo	"/var/lib/maia/scripts/configtest.pl" 

echo 
echo 	"If that passes check the web-based maia configuration test"
echo	"at http://$host/maia/admin/configtest.php"
echo
echo	"if everything passes, create the initial maia user"
echo	"at http://$host/maia/internal-init.php"
echo

# some useful aliases
cat contrib/bashrc.local.sh >>  /etc/bash.bashrc
