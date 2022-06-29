FROM wordpress:6.0.0-php7.4-fpm-alpine
# Install LDAP for Next Active Directory Integration Plugin.
RUN set -ex; \
        apk add --no-cache --virtual .build-deps \
        openldap-dev; \
        docker-php-ext-install ldap; \
        docker-php-ext-enable ldap;

RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini; \
        rm /usr/local/etc/php/php.ini-development; \
        sed -i -e 's/memory_limit\ =\ 128M/memory_limit\ =\ 256M/g' /usr/local/etc/php/php.ini;

RUN touch /usr/local/etc/php/conf.d/uploads.ini \
        && echo "upload_max_filesize = 512M;" >> /usr/local/etc/php/conf.d/uploads.ini \
        && echo "post_max_size = 512M;" >> /usr/local/etc/php/conf.d/uploads.ini;

RUN sed -i 's/max_execution_time = 30/max_execution_time = 300/' /usr/local/etc/php/php.ini \
        && sed -i 's/max_input_time = 30/max_input_time = 300/' /usr/local/etc/php/php.ini;
