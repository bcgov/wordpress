#!/bin/bash
chmod -R 770 /var/www/html/wp-content
composer config allow-plugins.composer/installers true;
composer install;


sleep infinity;