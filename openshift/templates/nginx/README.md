# Nginx Deployment

## Variables
```bash
export OC_ENV="dev" #(dev|test|prod);
export OC_SITE_NAME="cleanbc" # Site name otherwise defaults to global
export OC_APP_DOMAIN="cleanbc-dev.apps.silver.devops.gov.bc.ca" #unique url
export OC_POOL_NAME="pool" # Pool name otherwise defaults to pool
```

## Routes for Nginx.
**IMPORTANT**  `APP_DOMAIN` setting should point to the hostname of where the WordPress instance will reside.

* Deploy nginx Route and Service that permit the outside world to reach the web server.
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p APP_DOMAIN=${OC_APP_DOMAIN} -f openshift/templates/nginx/deploy-route.yaml | oc apply -f -`