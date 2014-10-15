#!/bin/bash

NI_DIR="/nidata"

echo "cat logo"
# Branding...
cat "$NI_DIR/nilogo.txt"

#sudo adduser newint2
#sudo chpasswd << 'END'
#newint2:root
#END
echo "su to postgres"
su - postgres

echo "cat sql to psql"
cat "$NI_DIR/psql.txt" | psql

echo "exit postgres user"
#exit

echo "su to newint2"
su - newint2

echo "populate newint2 db with data"
psql newint2 < $NI_DIR/newint2.sql


echo "run command to update settings.php"
IFS=" " read -a fields <<< "$1"

s='$databases['
d=''
e='),);'
a=''
for (( i=0 ; i < ${#fields[@]} ; i++ )) ; do
    f=${fields[i]}
    IFS=: read -a vals <<< "$f"
    key=${vals[0]}
    if [ "$key" = "name" ]; then
      s=$s"'${vals[1]}'] => array('default' => array("
    else
      d=$d"'${vals[0]}' => '${vals[1]}',"
    fi 
    last=$(( i+1 == ${#fields[@]} ))
    if [ last ]; then
      a=$s$d$e
    fi
done
chmod 777 /var/www/drupal7/sites/default/settings.php 
echo $a >> /var/www/drupal7/sites/default/settings.php

