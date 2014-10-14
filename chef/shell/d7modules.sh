#!/bin/bash

NI_DIR="/nidata"

# Branding...
cat "$NI_DIR/nilogo.txt"


# Enable and Disable Drupal Modules.
echo "Make sure we're in the right directory"
cd /var/www/drupal7

# Setup Drupal
echo "Cloning Drupal7 repo"
git clone --branch 7.x http://git.drupal.org/project/drupal.git .
echo "Drush installing site"
drush @drupal7 si standard -ydv
# echo "Running drush make file --no-core"
# drush make /nidata/drupal7.make --no-core -y


echo "Copy custom module to drupal install"
cp -R /nidata/custom_modules /var/www/drupal7/sites/all/modules/

echo "Download selected modules"
for dl in $1
do
  drush dl $dl -y
done

echo "Disabling selected modules"
for dis in $2
do
  drush dis $dis -y
done

echo "Enabling selected modules"
for en in $3
do
  drush en $en -y
done


