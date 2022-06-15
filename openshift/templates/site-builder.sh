#!/usr/bin/env bash
#set -euo pipefail

if [ ! -z "${OC_DEPLOY_PROJECT}" ] && [ ! -z "${APP_DOMAIN}" ] && [ ! -z "${SITE_NAME}" ] && [ ! -z "${POOL_NAME}" ]; then
    echo >&2 "Project:   ${OC_DEPLOY_PROJECT}"
    echo >&2 "App Name:  ${APP_DOMAIN}"
    echo >&2 "Site Name: ${SITE_NAME}"
    echo >&2 "Pool Name: ${POOL_NAME}"
    
    whoAmI="$(oc whoami 2> /dev/null)"
    # This means i am logged in.
    if [ ! -z "${whoAmI}" ]; then
        templates="$(dirname $0)";
        #apply=""
        apply=" | oc apply -f -"
        printf >&2 "\nStarting Build......with user ${whoAmI}\n"

        printf >&2 "\nMARIADB SETUP\n"
        echo "Setting up secrets"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -f ${templates}/mariadb/secrets.yaml | oc apply --overwrite=false -f -
        echo "Setting up configs"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME}  -f ${templates}/mariadb/config.yaml | oc apply --overwrite=false -f -
        echo "Setting up volume"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p POOL_NAME=${POOL_NAME} -f ${templates}/mariadb/volume.yaml | oc apply --overwrite=false -f -
        echo "Deploying"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p POOL_NAME=${POOL_NAME} -f ${templates}/mariadb/deploy.yaml | oc apply -f -

        printf >&2 "\nNGINX SETUP\n"
        echo "Setting up config"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p NGINX_CONF="$(envsubst '$APP_NAME,$SITE_NAME' < ${templates}/nginx/conf/wordpress.conf | cat -)" -f ${templates}/nginx/config.yaml | oc apply -f -
        echo "Setting up service and routes"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p APP_DOMAIN=${APP_DOMAIN} -f ${templates}/nginx/deploy-route.yaml | oc apply --overwrite=false -f -

        printf >&2 "\nWORDPRESS SETUP\n"
        echo "Setting up secrets"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -f ${templates}/wordpress/secrets.yaml | oc apply --overwrite=false -f -
        echo "Setting up configs"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p APP_DOMAIN=${APP_DOMAIN} -p WORDPRESS_MULTISITE=0 -f ${templates}/wordpress/config.yaml | oc apply --overwrite=false -f -
        echo "Setting up volume"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p POOL_NAME=${POOL_NAME} -f ${templates}/wordpress/volume.yaml | oc apply -f -
        echo "Deploying"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p POOL_NAME=${POOL_NAME} -f ${templates}/wordpress/deploy-nginx-wordpress.yaml | oc apply -f -

        printf >&2 "\nBACKUPS SETUP\n"
        echo "Setting up configs"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -f ${templates}/backups/config.yaml | oc apply -f -
        echo "Setting up volumes"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p POOL_NAME=${POOL_NAME} -f ${templates}/backups/volume-backup.yaml | oc apply -f -
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p POOL_NAME=${POOL_NAME} -f ${templates}/backups/volume-verification.yaml | oc apply -f -
        echo "Setting up cron conainer"
        oc process -p ENV_NAME=${OC_DEPLOY_PROJECT} -p SITE_NAME=${SITE_NAME} -p POOL_NAME=${POOL_NAME} -f ${templates}/backups/cron.yaml | oc apply -f -
    else
        printf >&2 "$(oc whoami)"
    fi
else
    echo >&2 'Require variables to be set, run: export OC_DEPLOY_PROJECT="test" APP_DOMAIN="des-test.apps.silver.devops.gov.bc.ca" SITE_NAME="des" POOL_NAME="pool-name"'
fi
