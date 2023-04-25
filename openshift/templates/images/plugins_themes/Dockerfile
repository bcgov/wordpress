FROM composer:lts as composer

# Install composer
WORKDIR /html/
#VOLUME /html/wp-content

# Install the plugins
COPY composer.json composer.json
COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk add \
  zip \
  unzip
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer \
    && chmod -R 770 /html composer.json \
    && mkdir -p /html/wp-content/plugins

ENTRYPOINT ["/entrypoint.sh"]