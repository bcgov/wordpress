# OpenShift uses version from buildconfig - Don't update
# We are using the image wordpress:php7.4-fpm-alpine which deploys WordPress 6.1 locally.  
# This means you will have to update your WordPress manually to the latest version.
# To do this use the command wp core update. NOTE: You must have wp_cli installed to run this command.

FROM wordpress:php7.4-fpm-alpine
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