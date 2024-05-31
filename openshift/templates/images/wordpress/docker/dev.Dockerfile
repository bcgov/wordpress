# OpenShift uses version from buildconfig - Don't update
FROM wordpress:6-php8.3-fpm-alpine
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