FROM wordpress:6.0.0-php7.4-fpm-alpine
# Install LDAP for Next Active Directory Integration Plugin.
RUN set -ex; \
	apk add --no-cache --virtual .build-deps \
        openldap-dev; \
	docker-php-ext-install ldap; \
    docker-php-ext-enable ldap; \