#!/usr/bin/env bash

# is the default maia db password to be changed?
MPRAW=`grep MAIAPASS installer.tmpl | wc -l`
NEEDMP=`eval echo $MPRAW`
if [ $NEEDMP -gt 0 ]; then
  ./update-maia-pw.sh
else
  cp original/maia.conf.dist maia.conf 
  cp original/maiad.conf.dist maiad.conf 
  cp original/config.php.dist config.php
fi

# modify the working copy of maiad.conf in place
HOST=`grep HOST installer.tmpl | awk -F\= '{ print $2 }'`
FQDN=`grep FQDN installer.tmpl | awk -F\= '{ print $2 }'`
DOMAIN=`grep DOMA installer.tmpl | awk -F\= '{ print $2 }'`

export HOST FQDN DOMAIN

sh inline-edit.sh __DOMAIN__  $DOMAIN maiad.conf
sh inline-edit.sh __HOST__ $HOST maiad.conf
sh inline-edit.sh yourdomain.tld  $DOMAIN maiad.conf
sh inline-edit.sh host.domain.tld $HOST maiad.conf


