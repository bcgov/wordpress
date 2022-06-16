# Backups
In order to restore backups you will need to utilize the sidecar, this needs to be deployed, and the pod needs to be run. See deployment of sidecar for more information.

## Variables
```bash
export OC_ENV="dev" #(dev|test|prod)
export OC_SITE_NAME="cleanbc" # Site name otherwise defaults to global
export OC_POOL_NAME="pool" # Pool name otherwise defaults to pool
```

## Backup Deployment

### Configs
* This sets up the database connection string.
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME}  -f openshift/templates/backups/config.yaml | oc apply -f -`

### Cron
* This sets up the cron job to deploy the container to do the backups.
* `oc process -p ENV_NAME=${OC_ENV} -p SITE_NAME=${OC_SITE_NAME} -p POOL_NAME=${OC_POOL_NAME}  -f openshift/templates/backups/cron.yaml | oc apply -f -`

### Volume Persistent Storage
* Creates backup volumes for storing db backups, and a location to restore netapp-file-backup storage class backups.
* `oc process -p ENV_NAME=${OC_ENV} -p POOL_NAME=${OC_POOL_NAME} -f openshift/templates/backups/volume-backup.yaml | oc apply -f -`
*  Verification of database backups.
*  `oc process -p ENV_NAME=${OC_ENV} -p POOL_NAME=${OC_POOL_NAME} -f openshift/templates/backups/volume-verification.yaml | oc apply -f -`


## Database Backups
* Once this is setup for production, there should be no further requirements, except occasionally verification of database being saved.

### Saving DB
* The cron and configurations of the OS CronJob determines the [backup options](https://developer.gov.bc.ca/Backup-Container) of the database.

### Restoring DB
* Use the sidecar, see instructions for deploying the sidecar.
* Both the DB (/home/sidecar/backups/db) and the file (/home/sidecar/backups/html) backups are mounted in the sidecar.

```bash
# Restore backup db, first gzip (-d) and echo (-c), then pipe into mysql.
gzip -cd ~/backups/db/daily/test.sql.gz | mysql -u $WORDPRESS_DB_USER -p$(cat $MYSQL_PASSWORD_FILE) -h wordpress-mariadb $WORDPRESS_DB_NAME
```

## File Backups
* The wordpress-php-fpm pvc (All WordPress) uses the ```netapp-file-backup``` storageClassName, which is the same according to [Bcgov OpenShift Storage Solutions Document](https://developer.gov.bc.ca/Persistent-Storage-Services) as the ```netapp-file-standard```
* This is being backed up according to the [OCP4 Backup and Restore Document](https://developer.gov.bc.ca/OCP4-Backup-and-Restore)
    * As of the time of this writing it does full backups monthly, incremental backups daily, and retained for 90 days.
* A manual backup can be done by ```rsync -a /var/www/html/ /home/sidecar/backups/html/```
 
### Restoring File backups.
* Request for backup as per [OCP4-Backup-and-Restore Document](https://developer.gov.bc.ca/OCP4-Backup-and-Restore)
    * https://github.com/BCDevOps/devops-requests/issues - add an issue, in the future there might be a template for this request.
* And request it uses pvc **wordpress-php-fpm-backup-prod**, and use a subfolder /restore
* Once files are in the restore folder, update the root folder /home/sidecar/backups/html with contents of the /restore folder
* Ensure the files to be restored is in the /home/sidecar/backups/html
* Switch from regular volume to backup volume as indicated below. (Your Instance is now using the backup volume, this is only temporary)  
* Use the sidecar, see instructions for deploying the sidecar.
* Do a ```rsync -a --exclude=restore /home/sidecar/backups/html/ /var/www/html/``` 
    * you might have to delete the files in /var/www/html, but **WARNING** make sure you know what you are doing.
* Switch from backup volume to regular volume as indicated below, so now WordPress should be using restored files.