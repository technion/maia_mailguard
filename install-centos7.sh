# testing - call info gathering script, then use params for install 

echo 
echo "this script is meant for Centos 7" 
echo 
echo -n "<ENTER> to continue or CTRL-C to stop..."
read junk
echo 

# get the info, write parames to a file
./get-info.sh

# find out what we need to change
./process-changes.sh

# continue with install

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

mkdir -p /etc/maia
cp maia.conf maiad.conf /etc/maia/

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
mysqladmin create maia
mysql maia < maia-mysql.sql 
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
cp config.php /var/www/html/maia/
mkdir /var/www/cache
chown maia.apache /var/www/cache
chmod 775 /var/www/cache

echo
echo "reloading http server"
systemctl restart httpd

echo "stage 2 complete"
# call postfix setup script
./postfix-setup.sh

systemctl restart postfix

host=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`

echo
echo	"any other site specific MTA configuration can be applied now - "
echo

echo 
echo 	"at this point, a good sanity check would be to run"
echo	"/var/lib/maia/scripts/configtest.pl" 
echo 
echo 	"If that passes check the web at /maia/admin/config test"
echo	"at http://$host/maia/admin/configtest.php"
echo
echo	"if everything passes, create the initial maia user"
echo	"at http://$host/maia/internal-init.php"
echo

# some useful aliases
cp contrib/bashrc.local.sh /etc/profile.d/
