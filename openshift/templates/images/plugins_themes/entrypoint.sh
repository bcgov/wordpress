#!/bin/bash
php --version
composer --version

rm composer.lock

if [ -d "/var/www/html/vendor" ]; then
  echo 'prepare for install removing old vendor folder'
  rm -rf /var/www/html/vendor
fi
if [ -d "/var/www/html/wp-content" ]; then
  echo 'prepare for install removing old wp-content folder'
  rm -rf /var/www/html//wp-content
fi

echo 'Composer install at build location'
composer install

if [ -d "/var/www/html/rollback" ]; then
  echo 'Deleting previous rollback'
  rm -rf /var/www/html/rollback/*
fi

if [ -d "/var/www/html/current" ]; then
  echo 'Creating new rollback ....moving current to rollback'
  cp -r /var/www/html/current/* /var/www/html/rollback/
  rm -rf /var/www/html/current/*
fi

echo 'Updating current deployment'
ls -la /var/www/html/current
ls -la 
echo 'Moving wp-content'
mv wp-content /var/www/html/current/wp-content
echo 'Moving vendor'
mv vendor /var/www/html/current/vendor
