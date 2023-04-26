#!/bin/bash
cp /composer.json /var/www/html/wp-content/composer.json
cd /var/www/html/wp-content
composer install;
sleep infinity;
