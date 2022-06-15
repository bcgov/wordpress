# OpenShift Deployments

## Base images
Create all [base images](./dockerhub-imagestreams/README.md) 

## Build images
Create [build images](./images/README.md)

## MariaDB configs and deployments
[MariaDB configs and deployments](./mariadb/README.md)

## Nginx configs
[Nginx configs](./nginx/README.md)

## Wordpress configs and deployments
[WordPress configs and deployments](./wordpress/README.md)

## Sidecar deployment
[Sidecar utility deployment](./sidecar/README.md)

## Backups
[Backup deployments](./backups/README.md)

## Create a new site
[Create a site script](./site-builder.sh)


## Image versions

| Image | Version | Description |
| ----- | ------- | ----------- |
| alpine | 3.15.4 | Base Alpine linux |
| mariadb | 10.6.8-r0 | MariaDB version that gets build in base-images via Dockerfile. Dependent on the [Alpine version](https://pkgs.alpinelinux.org/packages?name=mariadb&branch=v3.15): |
| nginx | 1.21.6-alpine | Nginx web server, used to serve WordPress / PHP |
| wordpress | 6.0.0-php7.4-fpm-alpine | PHP-FPM for WordPress |
| ubuntu | 22.04| Used for the sidecar |