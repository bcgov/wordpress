# WordPress Cloud

## OpenShift
* All oc commands in repo documentation are meant to be run from the root directory.

### Images

| Image | Version | Description |
| ----- | ------- | ----------- |
| alpine | 3.15.4 | Base Alpine linux |
| mariadb | 10.6.8-r0 | MariaDB version that gets build in base-images via Dockerfile. Dependent on the [Alpine version](https://pkgs.alpinelinux.org/packages?name=mariadb&branch=v3.15): |
| nginx | 1.21.6-alpine | Nginx web server, used to serve WordPress / PHP |
| php-fpm | 7.4.29-fpm-alpine | PHP-FPM for WordPress |
| WordPress | 5.9.3 | WordPress Core. The appropriate version can be found at: https://wordpress.org/download/releases/ |
| ubuntu | 22.04| Used for the sidecar |

### Volumes

### Naming Convention
Use the convention [product]-[service component]-[pool_name] For example:
* `wordpress-mariadb-trek`
* `wordpress-mariadb-commencal`

### Todo
* Look into bringing in Wordpress php-fpm-74 not raw php (might have been done this way due to permissions and configurations)
* Look into bring mariadb base image (might have been done this way due to permissions and configurations).
* Need a way of ensuring that images are monitored for security and maintenance (possible a email list, rss feeds)
  * Alpine
  * nginx
  * mariadb
  * WordPress
  * php-fpm
  * ubuntu
* Process of incorporating updates/fixes.
* Reviewing image naming conventions from docker -> base images -> final images.
* All Todo should have a Jira ticket associated with it.
* Update Nginx configuration to support multi-site.
