#!/usr/bin/env bash

PASSWD='password'

NEWPW=`grep MAIAPASS installer.tmpl | awk -F\= '{ print $2 }'`
PWCHANGE=`echo $NEWPW | awk -F\= '{ print $2 }' | wc -l`
[ $PWCHANGE -eq 1 ] && export PASSWD=$NEWPW

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
