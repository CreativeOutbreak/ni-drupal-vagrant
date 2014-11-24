#!/bin/bash

NI_DIR="/vagrant_nidata"

sudo cp "$NI_DIR/drupal7.dev" /etc/apache2/sites-available/

sudo a2ensite drupal7.dev

sudo apachectl graceful

echo "Done.";
