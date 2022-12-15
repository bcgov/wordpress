# Dockerhub Image streams

These are docker image streams which are pulled from docker-remote.artifacts.developer.gov.bc.ca.
This remediates the issue with restrictions from dockerhub.

## Image Streams

### Alpine Image
* Used as a base image to create mariadb.
* alpine:3.15.4 -> alpine
  * `oc process -f openshift/templates/dockerhub-imagestreams/alpine.yaml | oc apply -f -`

### WordPress image with php-fpm
* Used as an initial php-fpm base, then adds php configs for WordPress, then gets used for WordPress.
* wordpress:6.1.1-php7.4-fpm-alpine
  * `oc process -f openshift/templates/dockerhub-imagestreams/wordpress.yaml | oc apply -f -`

### Nginx
* Used as a base image for web server
* nginx:1.23.1-alpine -> nginx
  * `oc process -f openshift/templates/dockerhub-imagestreams/nginx.yaml | oc apply -f -`

### Maintenance sidecar
* Used for the base image of the maintenance sidecar.
* ubuntu:22.04 -> ubuntu
  * `oc process -f openshift/templates/dockerhub-imagestreams/ubuntu.yaml | oc apply -f -`
