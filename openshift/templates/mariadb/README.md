# MariaDB Deployment
The database used for WordPress deployments.

## Variables
```bash
export OC_ENV="dev" #(dev|test|prod)
export OC_SITE_NAME="cleanbc" # Site name otherwise defaults to global
export OC_POOL_NAME="pool" # Pool name otherwise defaults to pool
```

## Secrets

The secrets template is set to automatically generate random passwords for you. If you would like to specify custom passwords, you can specify them with -p arguments. Do only one or the other of the following commands, not both.

### Manually setup passwords
* `oc process -p ENV_NAME=${OC_ENV} -p MYSQL_PASSWORD=changeTHISstring -p MYSQL_ROOT_PASSWORD=changeTHISstring -f openshift/templates/mariadb/secrets.yaml | oc apply -f -`
  
### Automatically Setup passwords
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -f openshift/templates/mariadb/secrets.yaml | oc apply -f -`

## Volume Persistent Storage
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -f openshift/templates/mariadb/volume.yaml | oc apply -f -`

## Deploy
* Deploy mariadb container and its Service that makes the mariadb port reachable by the php-fpm container
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p POOL_NAME=${OC_POOL_NAME} -f openshift/templates/mariadb/deploy.yaml | oc apply -f -`