#!/bin/bash
# Install the plugins and themes in 
cp /composer.json /var/www/html/composer.json
cd /var/www/html/

composer install;
