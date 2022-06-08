# MariaDB Deployment
The database used for WordPress deployments.

## Variables
```bash
export OC_DEPLOY_PROJECT="dev" #(dev|test|prod)
export SITE_NAME="cleanbc" # Site name otherwise defaults to global
export POOL_NAME="pool" # Pool name otherwise defaults to pool
```

## Secrets

The secrets template is set to automatically generate random passwords for you. If you would like to specify custom passwords, you can specify them with -p arguments. Do only one or the other of the following commands, not both.

### Manually setup passwords
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p MYSQL_PASSWORD=changeTHISstring -p MYSQL_ROOT_PASSWORD=changeTHISstring -f openshift/templates/mariadb/secrets.yaml | oc apply -f -`
  
### Automatically Setup passwords
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -f openshift/templates/mariadb/secrets.yaml | oc apply -f -`

## Configs
* SITE_NAME
  * Under 60 characters 
  * characters upper/lower alpha, numeric, and underscore. "A-Z a-z 0-9 _"
  * First character must start with a-z A-Z
  * example sitea, will create db names of sitea_dev, sitea_test, sitea_prod in the corresponding project (dev|test|prod)
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME}  -f openshift/templates/mariadb/config.yaml | oc apply -f -`

## Volume Persistent Storage
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p POOL_NAME=${POOL_NAME} -f openshift/templates/mariadb/volume.yaml | oc apply -f -`

## Deploy
* Deploy mariadb container and its Service that makes the mariadb port reachable by the php-fpm container
* `oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p POOL_NAME=${POOL_NAME} -f openshift/templates/mariadb/deploy.yaml | oc apply -f -`