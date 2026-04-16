# OpenShift uses version from buildconfig - Don't update.
# Local dev intentionally stays on PHP 7.4 while pinning WordPress 6.8.1.

FROM wordpress:php7.4-fpm-alpine

RUN set -ex; \
        apk add --no-cache --virtual .fetch-deps curl; \
        version='6.8.1'; \
        sha1='52d5f05c96a9155f78ed84700264307e5dea14b4'; \
        curl -o /tmp/wordpress.tar.gz -fL "https://wordpress.org/wordpress-${version}.tar.gz"; \
        echo "${sha1} */tmp/wordpress.tar.gz" | sha1sum -c -; \
        find /usr/src/wordpress -mindepth 1 -maxdepth 1 ! -name 'wp-config-docker.php' -exec rm -rf '{}' +; \
        tar -xzf /tmp/wordpress.tar.gz -C /usr/src/wordpress --strip-components=1; \
        rm /tmp/wordpress.tar.gz; \
        apk del .fetch-deps; \
        chown -R www-data:www-data /usr/src/wordpress

# Install LDAP for Next Active Directory Integration Plugin.
RUN set -ex; \
        apk add --no-cache --virtual .build-deps \
        openldap-dev; \
        docker-php-ext-install ldap; \
        docker-php-ext-enable ldap;

COPY php.conf.ini /usr/local/etc/php/conf.d/php.ini

# Required for installing the WP unit testing environment
RUN apk add subversion
RUN apk add mysql mysql-client