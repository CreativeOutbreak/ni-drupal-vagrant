#!/bin/bash

NI_DIR="/nidata"

# Branding...
# cat "$NI_DIR/nilogo.txt"

# Setup Drupal
echo "Cloning Drupal7 repo"

DIR="$NI_DIR/drupal7"

if [ -d "$DIR" ]; then
  # look for empty dir
  cd $DIR 
  if [ "$(ls -A $DIR)" ]; then
    git pull origin 7.x
  else
    git clone --branch 7.x http://git.drupal.org/project/drupal.git .
  fi
else
  mkdir $DIR
  cd $DIR
  git clone --branch 7.x http://git.drupal.org/project/drupal.git .
fi

cp -R "$DIR/." /var/www/drupal7/. 

#git clone --branch 7.x http://git.drupal.org/project/drupal.git .
echo "Drush installing site"
drush @drupal7 si standard -y
# echo "Running drush make file --no-core"
# drush make /nidata/drupal7.make --no-core -y


