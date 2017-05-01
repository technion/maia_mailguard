#!/bin/sh

PASSWORD='password'
# set mysql password
if [ $# -eq 1 ]; then
  PASSWORD=$1
fi

echo "password = $PASSWORD"
exit

mysql <<ZZ
GRANT CREATE, DROP, ALTER, SELECT, INSERT, UPDATE, DELETE ON maia.* TO maia@localhost IDENTIFIED BY "$PASSWORD";
ZZ
