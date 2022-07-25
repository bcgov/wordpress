# Images

Base images are images that would use dockerhub image streams to create an additional layer to add more functionality or modify existing functionality of the image.

## Image Streams

### MariaDB
* Is the image used to create the database container.
* alpine -> mariadb-base
  * `oc process -f openshift/templates/images/mariadb/build.yaml | oc apply -f -`

#### Test MariaDB image
* Please verify image by running.  `docker compose -f openshift/templates/images/mariadb/docker-compose.yaml up --build`
* This just confirms that the image contains all files, as updating mariadb versions can change these files.
* clean up docker resources: `docker compose -f openshift/templates/images/mariadb/docker-compose.yaml down`


### Nginx 
* Creates the nginx web server.
* nginx:1.23.1-alpine -> wordpress-nginx-run
  *  `oc process -f openshift/templates/images/nginx/build.yaml | oc apply -f -`

### WordPress
* Creates WordPress core 6.0.0
* wordpress:6.0.0-php7.4-fpm-alpine -> wordpress-wordpress-run
  * `oc process -f openshift/templates/images/wordpress/build.yaml | oc apply -f -`

### Sidecar
* Creates Sidecar image used for WordPress maintenance and diagnostics.
* ubuntu -> wordpress-sidecar
  * `oc process -f openshift/templates/images/sidecar/build.yaml | oc apply -f -` 

## Naming Conventions
### Base Images
>A base image is an image that has no parent layer.

Use the same convention as dockerhub, specifying the full version tag where possible. For example:
* `alpine:3.15.4`
* `mariadb:10.5.13-r0`
* `nginx:1.23.1-alpine`

### Intermediate Images
>An Intermediate image is any container image that relies on a base image and is used as a building block to build a standalone image.

Use the convention [product]-[service component]-build:tag. For example:
* `wordpress-nginx-build:dev`

### Application Images
>These images are what end applications consume. Use cases range from databases, web servers, and applications.

Use the convention [product]-[service component]-run:tag. For example:
* `oc tag wordpress-nginx-run:dev wordpress-nginx-run:test`

### Recommended Tags
* `dev`
* `test`
* `prod`

### Recommended Labels
| Name | Description | Example |
|------|:-----------:|--------:|
| app.kubernetes.io/part-of | The name of the top level software system this resource is part of | ticketmonster
| app.kubernetes.io/name | The name, reflecting component. | mysql
| app.kubernetes.io/component | This is the role/type of the component | frontend
| app.kubernetes.io/version	| The current version of the application |	5.7.21	| string
| app.kubernetes.io/instance | A unique name identifying the application, usually used if different from `app.kubernetes.io/name` | accounts
