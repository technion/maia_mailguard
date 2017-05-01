#!/usr/bin/env bash

PASSWD='password'
PWCHANGE=0

NEWPW=`grep MAIAPASS installer.tmpl | awk -F\= '{ print $2 }'`
[ ${NEWPW}X != "X" ] && PWCHANGE=1

[ $PWCHANGE -eq 1 ] && export PASSWD=$NEWPW

export PASSWD PWCHANGE
echo "PWCHANGE = $PWCHANGE"
echo "PASSWORD = $PASSWD"

# is a mysql root password set?
RPRAW=`grep ROOTPASS installer.tmpl | wc -l`
NEEDRP=`eval echo $RPRAW`

if [ $NEEDRP -gt 0 ]; then
  export rootpw=`grep ROOTPASS installer.tmpl | awk -F\= '{ print $2 }'`
   echo "granting privileges to maia"
   ./grants-with-pw
else 
   echo "granting privileges to maia (NP)"
   ./grants-sans-pw
fi
