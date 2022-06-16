# MariaDB Deployment
The database used for WordPress deployments.

## Variables
```bash
export OC_ENV="dev" #(dev|test|prod)
export OC_SITE_NAME="cleanbc" # Site name otherwise defaults to global
export OC_POOL_NAME="pool" # Pool name otherwise defaults to pool
```

## Configs
* SITE_NAME
  * Under 60 characters 
  * characters upper/lower alpha, numeric, and underscore. "A-Z a-z 0-9 _"
  * First character must start with a-z A-Z
  * example sitea, will create db names of sitea_dev, sitea_test, sitea_prod in the corresponding project (dev|test|prod)
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p APP_DOMAIN=${OC_APP_DOMAIN} -p WORDPRESS_MULTISITE=0  -f openshift/templates/config/config.yaml | oc apply -f -`
