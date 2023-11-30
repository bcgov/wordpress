# OpenShift uses version from buildconfig, and renames images composer -> composer-source, and php -> php-source
FROM composer-source AS composer

FROM php-source

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt update && apt install \
  zip \
  unzip

COPY entrypoint.sh /entrypoint.sh
WORKDIR /var/www/html/
ENTRYPOINT ["/entrypoint.sh"]
