# Sidecar

* Because the containers for WordPress have minimum tooling for size and security, maintenance tasks can be performed by using the sidecar deployment.
* This deployment should only be used when doing maintenance tasks, and then turned down.

## Variables
```bash
export OC_ENV="dev" #(dev|test|prod)
export OC_NAMESPACE="mynamespace"
export OC_SITE_NAME="cleanbc" # Site name otherwise defaults to global
export OC_APP_DOMAIN="cleanbc-dev.apps.silver.devops.gov.bc.ca" #unique url
export OC_POOL_NAME="pool" # Pool name otherwise defaults to pool
```

## Deployment
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p POOL_NAME=${OC_POOL_NAME} -p RUN_AS_USER=$(oc describe project ${OC_NAMESPACE}-${OC_ENV} | grep openshift.io/sa.scc.uid-range | cut -d '=' -f 2 | cut -d '/' -f 1) -f openshift/templates/sidecar/deploy.yaml | oc apply -f -`

## Tools provided:
* Ubuntu
  * apt 
    * works, but may sometimes have issues because things are run as a user, not real root.
  * git
  * tar
  * ...etc
* PHP Interpreter
  * Composer
  * WP-CLI
* Mariadb tools suite
  * mysql
  * mysqldump