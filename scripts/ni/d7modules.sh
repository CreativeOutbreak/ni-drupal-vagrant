#!/bin/bash

NI_DIR="/nidata"

# Branding...
#cat "$NI_DIR/nilogo.txt"

# Modules to download
dlmod=("apachesolr" "facetapi" "migrate" "ctools")

# Modules to disable
dismod=("overlay")

# Modules to enable
enmod=("apachesolr_access" "apachesolr" "apachesolr_search" "current_search" "facetapi" "newint_migrate" "migrate_ui")

echo "soft link custom module to drupal install"
ln -s /nidata/custom_modules /var/www/drupal7/sites/all/modules/custom_modules

# Enable and Disable Drupal Modules.
echo "Make sure we're in the right directory"
cd /var/www/drupal7


echo "Download selected modules"
for dl in ${dlmod[@]}
do
  drush dl $dl -y
done

echo "Disabling selected modules"
for dis in ${dismod[@]}
do
  drush dis $dis -y
done

echo "Enabling selected modules"
for en in ${enmod[@]}
do
  drush en $en -y
done

echo "patching migrate module"
cd /vagrant/data/drupal7/sites/all/modules/migrate/
wget https://www.drupal.org/files/noderevision-1298724-14.patch
patch -p1 < noderevision-1298724-14.patch


