# use template files to update configs

cp template/maia.conf.tmpl maia.conf
cp template/maiad.conf.tmpl maiad.conf
cp template/config.php.tmpl config.php

passwd=`grep MAIAPASS installer.tmpl | awk -F\= '{ print $2 }'`

for i in maia.conf maiad.conf config.php
do
  sh inline-edit.sh __PASSWORD__  $passwd $i
done


