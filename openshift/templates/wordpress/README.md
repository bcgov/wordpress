# WordPress PHP-FPM

## Variables
```bash
export OC_ENV="dev" #(dev|test|prod)
export OC_SITE_NAME="cleanbc" # Site name otherwise defaults to global
export OC_APP_DOMAIN="cleanbc-dev.apps.silver.devops.gov.bc.ca" #unique url
export OC_POOL_NAME="pool" # Pool name otherwise defaults to pool
```

## Secrets

The secrets template is set to automatically generate random passwords for you. If you would like to specify custom passwords, you can specify them with `-p` arguments. Look inside `openshift/templates/wordpress-php-fpm/secrets.yaml` to see the full list of configurable parameters. One parameter is shown specified below for your reference convenience in a commented-out command listing; use it to construct a command line that specifies the custom items: simply add as many `-p KEY=value` argument pairs to the command as you wish.

### Manually set secrets for WordPress
* `oc process -p ENV_NAME=${OC_ENV} -p WORDPRESS_NONCE_SALT=changeTHISstring -f openshift/templates/wordpress/secrets.yaml | oc apply -f -`

### Automatically prepare secrets
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -f openshift/templates/wordpress/secrets.yaml | oc apply -f -`

## Volumes
* `oc process -p ENV_NAME=${OC_ENV} -p POOL_NAME=${OC_POOL_NAME} -f openshift/templates/wordpress/volume.yaml | oc apply -f -`

## Deployment
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p POOL_NAME=${OC_POOL_NAME} -f openshift/templates/wordpress/deploy-nginx-wordpress.yaml | oc apply -f -`
