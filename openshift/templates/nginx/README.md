# Nginx Deployment

## Variables
```bash
export OC_DEPLOY_PROJECT="dev" #(dev|test|prod);
export SITE_NAME="cleanbc" # Site name otherwise defaults to global
export APP_DOMAIN="cleanbc-dev.apps.silver.devops.gov.bc.ca" #unique url
export POOL_NAME="pool" # Pool name otherwise defaults to pool
```

## Configuration for Nginx
* Sets up the configuration for Nginx for WordPress and php-fpm.  This is the config file.
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p NGINX_CONF="$(envsubst '$APP_NAME,$SITE_NAME' < openshift/templates/nginx/conf/wordpress.conf | cat -)" -f openshift/templates/nginx/config.yaml | oc apply -f -`


## Routes for Nginx.
**IMPORTANT**  `APP_DOMAIN` setting should point to the hostname of where the WordPress instance will reside.

* Deploy nginx Route and Service that permit the outside world to reach the web server.
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p APP_DOMAIN=${APP_DOMAIN} -f openshift/templates/nginx/deploy-route.yaml | oc apply -f -`