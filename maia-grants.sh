#!/bin/sh

PASSWD='password'

NEWPW=`grep MAIAPASS installer.tmpl | awk -F\= '{ print $2 }'`
PWCHANGE=`echo $NEWPW | awk -F\= '{ print $2 }' | wc -l`
[ $PWCHANGE == 1 ] && export PASSWD=$NEWPW

# is a mysql root password set?
RPRAW=`grep ROOTPASS installer.tmpl | wc -l`
NEEDRP=`eval echo $RPRAW`

if [ $NEEDRP -gt 0 ]; then
  export rootpw=`grep ROOTPASS installer.tmpl | awk -F\= '{ print $2 }'`
   ./grants-with-pw
else 
   ./grants-sans-pw
fi
