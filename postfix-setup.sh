echo
echo "setting up postfix for maia spam/virus filtering"
echo

cp /etc/postfix/main.cf /etc/postfix/main.cf-save-$$
cp /etc/postfix/master.cf /etc/postfix/master.cf-save-$$

cat master.cf-append >> /etc/postfix/master.cf

postconf -e inet_interfaces=all
postconf -e content_filter=maia:[127.0.0.1]:10024

#hostname=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`
hostname=`grep FQDN installer.tmpl | awk -F\= '{ print $2 }'`
domain=`grep DOMAIN installer.tmpl | awk -F\= '{ print $2 }'`
postconf -e myhostname=${hostname}
postconf -e mydomain=${domain}

# do we need to add a relayhost?
relayhost=`grep RELAY installer.tmpl | awk -F\= '{ print $2 }'`
addrelay=`echo $relayhost | wc -l`
[ $addrelay ] && postconf -e relayhost=$relayhost

# the calling script needs to restart postfix after this returns
