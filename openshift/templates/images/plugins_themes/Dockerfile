FROM composer:lts AS composer

FROM php:8.0

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt update && apt install \
  zip \
  unzip

COPY entrypoint.sh /entrypoint.sh

WORKDIR /var/www/html/

ENTRYPOINT ["/entrypoint.sh"]
