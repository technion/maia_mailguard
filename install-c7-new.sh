# 
# todo - get maia password up front and configure the credentials
#   e.g. - 
#       postfix: domain, hostname, relayhost
#       db: maia pw: maia-grants.  maia.conf, maiad.conf, config.php
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
# not functional yet
#

myroothazpass=0
myrootwantpass=0
mydbpass=""
mynewdbpass=0

# check if it's the right platform
echo 
echo "this script is meant for Centos 7" 
echo 
echo "Hit <ENTER> to continue or CTRL-C to stop..."
read junk

# find out whether to set a new maia db password
echo -n "Do you wish to change the default maia password? (y/N)"
read junk
echo

[ "${junk}X" == "X" ] &&  junk="n"

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
[ "${junk}X" == "X" ] &&  junk="n"

if [ $junk == 'y' ] || [ $junk == 'Y' ]; then
  myroothazpass=1
  myrootwantpass=1
  echo "Enter the mysql root password and press [ENTER]:"
  read -s rootmypass
  echo
elif [ $junk == 'n' ] || [ $junk == 'N' ]; then
  echo -n "Do you wish to assign a mysql root password at this time? (y/N)"
  read junk
  echo
  [ "${junk}X" == "X" ] &&  junk="n"

  if [ $junk == 'y' ] || [ $junk == 'Y' ]; then
    myrootwantpass=1
    echo "Enter the mysql root password and press [ENTER]:"
    read -s rootmypass
    echo
    myroothazpass=1
  fi
fi

if [ $myroothazpass == 0 ]; then
  echo -n "there is no mysql root password set"
else
  echo "a root password is set for mysql"
  echo
fi


echo "ready to begin install?"
read junk
if [ $myroothazpass == 1 ]; then
  echo "mysql password for root: $rootmypass"
else 
  echo "mysql will remain without root password"
fi

if [ $mynewdbpass == 1 ]; then
  echo "mysql password for maia: $mydbpass"
else
  echo "default maia db password will be retained"
fi

echo
echo "are you sure?"
read junk
if [ $mynewdbpass == 1 ] || [ $myroothazpass == 1 ]; then
  echo "not yet implemented"
  exit 1
fi

# install stage 1 packages

# add epel and get up to date
yum install -y epel-release
yum -y update
#
yum install -y make gcc
yum install -y telnet
#
yum install -y file
yum install -y perl-DBI 
yum install -y spamassassin
yum install -y perl-Archive-Zip
yum install -y perl-BerkeleyDB
yum install -y perl-Convert-TNEF
yum install -y perl-Convert-UUlib
yum install -y perl-Digest-SHA1
yum install -y perl-DBD-MySQL perl-DBD-Pg
yum install -y perl-Data-UUID
yum install -y perl-Net-Server
yum install -y perl-Net-DNS-Nameserver
yum install -y perl-Text-CSV
yum install -y perl-Net-CIDR-Lite
yum install -y perl-LDAP
yum install -y perl-Unix-Syslog
yum install -y perl-Razor-Agent
yum install -y perl-Template-Toolkit
yum install -y perl-CPAN 
#
#
yum install -y clamav 
yum install -y clamav-update 
yum install -y clamav-data 
yum install -y clamav-server

yum install -y httpd httpd-tools

#
# echo "done with rpm installs"
#

#
# add maia user and chown all its files/dirs
#
useradd -d /var/lib/clamav clam
useradd -d /var/lib/maia maia
chmod 755 /var/lib/maia

# create and chown dirs
mkdir -p /var/log/maia
chown -R maia.maia /var/log/maia

mkdir -p /var/log/clamav
chown -R clam.clam /var/log/clamav/
chown -R clamupdate.clam /var/lib/clamav/
chmod 775 /var/lib/clamav/

mkdir /etc/maia
cp maia.conf.dist /etc/maia/maia.conf
cp maiad.conf.dist /etc/maia/maiad.conf

mkdir -p  /var/lib/maia/tmp
mkdir -p  /var/lib/maia/db
mkdir -p  /var/lib/maia/scripts
mkdir -p  /var/lib/maia/templates
cp maiad /var/lib/maia/
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

#
# install the systemd unit files -
#
cp maiad.service /lib/systemd/system/
cp clamd.service /lib/systemd/system/

# enable services
systemctl enable maiad.service
systemctl enable clamd.service

# provide config files
/usr/bin/cp clamd.conf freshclam.conf /etc

# fix clam/maia group memberships
usermod -G maia clam
usermod -G clam maia

#
# non-interactive cpan installs
#
curl -L http://cpanmin.us | perl - --sudo App::cpanminus

cpanm forks
cpanm IP::Country::Fast

echo "creating maia database..."
yum install -y mariadb mariadb-server
systemctl enable mariadb.service
systemctl start mariadb.service
mysqladmin -p $rootmypass create maia
mysql -p $rootmypass maia < maia-mysql.sql 
sh maia-grants.sh

echo "stage 1 install complete"

#
# the database should be working at this point.
#
# start maiad 
systemctl start maiad.service
# start clamd
systemctl start clamd.service
#
# load the spamassassin rulesets -
#
cp clamav.cf sanesecurity.cf /etc/mail/spamassassin/
/var/lib/maia/scripts/load-sa-rules.pl

echo
echo "installing php modules"
echo
yum install -y php
yum install -y php-pdo
yum install -y php-gd
yum install -y php-process
yum install -y php-xml
yum install -y php-mbstring
yum install -y php-mysql
yum install -y php-bcmath
yum install -y php-devel
yum install -y php-pear
yum install -y php-Smarty

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
chown maia.apache /var/www/html/maia/themes/*/compiled
cp php/config.php.dist /var/www/html/maia/config.php
mkdir /var/www/cache
chown maia.apache /var/www/cache
chmod 775 /var/www/cache

echo
echo "reloading http server"
systemctl restart httpd

echo "stage 2 complete"

echo
echo "setting up postfix for maia spam/virus filtering"
echo

cp /etc/postfix/main.cf /etc/postfix/main.cf-save-$$
cp /etc/postfix/master.cf /etc/postfix/master.cf-save-$$

cat master.cf-append >> /etc/postfix/master.cf

postconf -e inet_interfaces=all
postconf -e content_filter=maia:[127.0.0.1]:10024

systemctl restart postfix

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
cp contrib/bashrc.local.sh /etc/profile.d/
