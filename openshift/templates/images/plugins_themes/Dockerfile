FROM composer:lts as composer

# Install composer
WORKDIR /var/www/html
VOLUME /var/www/html/wp-content/plugins

# Install the plugins
COPY composer.json composer.json
COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk add \
  zip \
  unzip
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer \
    && chmod -R 770 /var/www/html/ composer.json

ENTRYPOINT ["/entrypoint.sh"]