#!/bin/bash

NI_DIR="/vagrant_nidata"

# sudo bash

sudo mkdir /var/www/drupal7
sudo echo "ServerName drupal_vagrant" >> /etc/apache2/apache2.conf
sudo cp "$NI_DIR/drupal7.dev" /etc/apache2/sites-available/
sudo a2ensite drupal7.dev
sudo apachectl graceful
sudo echo "127.0.0.1 drupal7.dev" >> /etc/hosts

echo "Done.";
