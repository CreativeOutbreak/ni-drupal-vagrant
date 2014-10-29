#!/bin/bash

NI_DIR="/nidata"

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
      s=$s"'${vals[1]}'] = array('default' => array("
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


echo "Clear Cache for drupal7"
drush @drupal7 cc all

#echo "Drupal modules"
#drush @drupal7 pml

echo "Print maz"
drush @drupal7 maz --all

echo "migrate tags"
drush @drupal7 mi NewIntTermSQL -v

echo "join other tables"
cat /nidata/second_join_views.sql | sudo -u newint2 psql newint2
