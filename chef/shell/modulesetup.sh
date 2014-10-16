#!/bin/bash

NI_DIR="/nidata"

# Branding...
cat "$NI_DIR/nilogo.txt"


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


echo "Copy custom module to drupal install"
cp -R /nidata/custom_modules /var/www/drupal7/sites/all/modules/

# Enable and Disable Drupal Modules.
echo "Make sure we're in the right directory"
cd /var/www/drupal7


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

echo "patching migrate module"
cd /vagrant/data/drupal7/sites/all/modules/migrate/
wget https://www.drupal.org/files/issues/noderevision-1298724-24.patch
patch -p1 < noderevision-1298724-24.patch 
