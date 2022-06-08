# This will be overridden by openshift runtime/build buildconfig ("from:" in the dockerStrategy).
FROM wordpress-php-fpm-build:dev

ARG WP_VERSION=5.9.3
ARG WP_SHA1=857defd25b3d01afd0758be7eb93d9bf949b97e7

RUN set -eux; \
	version="$WP_VERSION"; \
	sha1="$WP_SHA1"; \
	\
	curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$version.tar.gz"; \
	echo "$sha1 *wordpress.tar.gz" | sha1sum -c -; \
	\
# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
	tar -xzf wordpress.tar.gz -C /usr/src/; \
    # This allows for a mountable plugins directory
    rm -rf /usr/src/wordpress/wp-content/plugins; \
    # This allows for a mountable themes directory
    rm -rf /usr/src/wordpress/wp-content/themes; \
    # This allows for a mountable uploads directory
    rm -rf /usr/src/wordpress/wp-content/uploads; \
	rm wordpress.tar.gz; \
	\
	chown -R www-data:0 /usr/src/wordpress; \
	chown www-data:0 /var/www/html; \
	chmod 775 /var/www/html /usr/src/wordpress

COPY --chown=www-data:0 wp-config-docker.php /usr/src/wordpress/
COPY docker-entrypoint.sh /usr/local/bin/
