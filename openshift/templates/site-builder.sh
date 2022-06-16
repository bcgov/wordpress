#!/usr/bin/env bash
#set -euo pipefail

if [ ! -z "${OC_ENV}" ] && [ ! -z "${OC_APP_DOMAIN}" ] && [ ! -z "${OC_SITE_NAME}" ] && [ ! -z "${OC_POOL_NAME}" ]; then
    echo >&2 "Project:   ${OC_ENV}"
    echo >&2 "App Name:  ${OC_APP_DOMAIN}"
    echo >&2 "Site Name: ${OC_SITE_NAME}"
    echo >&2 "Pool Name: ${OC_POOL_NAME}"
    
    whoAmI="$(oc whoami 2> /dev/null)"
    # This means i am logged in.
    if [ ! -z "${whoAmI}" ]; then
        templates="$(dirname $0)";
        printf >&2 "\nStarting Build......with user ${whoAmI}\n"

        printf >&2 "\nCONFIG SETUP\n"
        oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p APP_DOMAIN=${OC_APP_DOMAIN} -p WORDPRESS_MULTISITE=0 -f ${templates}/config/config.yaml | oc apply --overwrite=false -f -
        
        printf >&2 "\nMARIADB SETUP\n"
        echo "Setting up secrets"
        oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -f ${templates}/mariadb/secrets.yaml | oc apply --overwrite=false -f -
        echo "Setting up volume"
        oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -f ${templates}/mariadb/volume.yaml | oc apply --overwrite=false -f -
        echo "Deploying"
        oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p POOL_NAME=${OC_POOL_NAME} -f ${templates}/mariadb/deploy.yaml | oc apply -f -

        printf >&2 "\nNGINX SETUP\n"

        echo "Setting up service and routes"
        oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p APP_DOMAIN=${OC_APP_DOMAIN} -f ${templates}/nginx/deploy-route.yaml | oc apply --overwrite=false -f -

        printf >&2 "\nWORDPRESS SETUP\n"
        echo "Setting up secrets"
        oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -f ${templates}/wordpress/secrets.yaml | oc apply --overwrite=false -f -
        echo "Setting up volume"
        oc process -p ENV_NAME=${OC_ENV} -p POOL_NAME=${OC_POOL_NAME} -f ${templates}/wordpress/volume.yaml | oc apply -f -
        echo "Deploying"
        oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p POOL_NAME=${OC_POOL_NAME} -f ${templates}/wordpress/deploy-nginx-wordpress.yaml | oc apply -f -

        printf >&2 "\nBACKUPS SETUP\n"
        echo "Setting up volumes"
        oc process -p ENV_NAME=${OC_ENV} -p POOL_NAME=${OC_POOL_NAME} -f ${templates}/backups/volume-backup.yaml | oc apply -f -
        oc process -p ENV_NAME=${OC_ENV} -p POOL_NAME=${OC_POOL_NAME} -f ${templates}/backups/volume-verification.yaml | oc apply -f -
        echo "Setting up cron conainer"
        oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p POOL_NAME=${OC_POOL_NAME} -f ${templates}/backups/cron.yaml | oc apply -f -
    else
        printf >&2 "$(oc whoami)"
    fi
else
    echo >&2 ''
    echo >&2 'Current Variables'
    env | grep -i oc_
    echo >&2 ''
    echo >&2 'Require variables to be set, run: export OC_ENV="test" OC_APP_DOMAIN="des-test.apps.silver.devops.gov.bc.ca" OC_SITE_NAME="des" OC_POOL_NAME="pool-name"'
fi
