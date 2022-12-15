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
| nginx | 1.23.1-alpine | Nginx web server, used to serve WordPress / PHP |
| wordpress | 6.1.1-php7.4-fpm-alpine | PHP-FPM for WordPress |
| ubuntu | 22.04| Used for the sidecar |

## Image references
The images above are referenced (and should be updated) in the following locations.
* alpine
    * [dockerhub-imagestreams/README.md](./dockerhub-imagestreams/README.md)
    * [dockerhub-imagestreams/alpine.yaml](./dockerhub-imagestreams/alpine.yaml)
    * [images/mariadb/docker/Dockerfile](./images/mariadb/docker/Dockerfile)

* mariadb
    * [images/mariadb/docker/Dockerfile](./images/mariadb/docker/Dockerfile)

* nginx
    * [dockerhub-imagestreams/nginx.yaml](./dockerhub-imagestreams/nginx.yaml)
    * [dockerhub-imagestreams/README.md](./dockerhub-imagestreams/README.md)
    * [images/README.md](./images/README.md)
    * [images/nginx/docker/Dockerfile](./images/nginx/docker/Dockerfile)

* wordpress
    * [dockerhub-imagestreams/README.md](./dockerhub-imagestreams/README.md)
    * [dockerhub-imagestreams/wordpress.yaml](./dockerhub-imagestreams/wordpress.yaml)
    * [images/README.md](./images/README.md)
    * [images/wordpress/docker/Dockerfile](./images/wordpress/docker/Dockerfile)

* ubuntu
    * [dockerhub-imagestreams/README.md](./dockerhub-imagestreams/README.md)
    * [dockerhub-imagestreams/ubuntu.yaml](./dockerhub-imagestreams/ubuntu.yaml)
    * [images/sidecar/docker/Dockerfile](./images/sidecar/docker/Dockerfile) |