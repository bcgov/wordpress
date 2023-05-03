FROM composer:lts AS composer

FROM php:8.0

COPY --from=composer /usr/bin/composer /usr/bin/composer

# RUN apk update && apk add \
#   zip \
#   unzip
# RUN curl -sS https://getcomposer.org/installer | \
#     php -- --install-dir=/usr/bin/ --filename=composer

COPY entrypoint.sh /entrypoint.sh

WORKDIR /var/www/html/

ENTRYPOINT ["/entrypoint.sh"]
