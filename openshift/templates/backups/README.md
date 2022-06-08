# Backups
In order to restore backups you will need to utilize the sidecar, this needs to be deployed, and the pod needs to be run. See deployment of sidecar for more information.

## Database Backups
* The below configuration is for deployment to test.
* For production replace ENV_NAME `test` with `prod` 
* Once this is setup for production, there should be no further requirements, except occasionally verification of database being saved.

### Saving DB
* The cron and configurations of the OS CronJob determines the [backup options](https://developer.gov.bc.ca/Backup-Container) of the database.

```bash
    # Add backup.conf string which is used to determine the service, port and database name.
    oc process -p ENV_NAME="test" -p BACKUP_CONFIG="mariadb=wordpress-mariadb:3306/bcfd_test" -f openshift/templates/backups/config.yaml | oc apply -f -

    # If adding multiple databases, consider using a backup file as a parameter. See https://github.com/BCDevOps/backup-container/blob/master/config/backup.conf
    # oc process -p ENV_NAME="test" -param-file=backup.yaml -f openshift/templates/backups/config.yaml | oc apply -f -

    # Creates volumes for database use netapp-file-backup, where verification uses netapp-file-standard
    # The full purpose of the verification has yet to be determined.
    oc process -p ENV_NAME="test" -f openshift/templates/backups/volume-backup.yaml | oc apply -f -
    oc process -p ENV_NAME="test" -f openshift/templates/backups/volume-verification.yaml | oc apply -f -

    # Add cron, This deploys a container which does the rolling backups for the db.
    oc process -p ENV_NAME="test" -f openshift/templates/backups/cron.yaml | oc apply -f -
```

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


# Switching from regular volume to backup volume.

```bash
# Deploy WordPress using backup volume.
oc process -p ENV_NAME="test" -p VOLUME_NAME="-backup" -f openshift/templates/wordpress-php-fpm/deploy.yaml | oc apply -f -
oc process -p ENV_NAME="test" -p VOLUME_NAME="-backup" -f openshift/templates/nginx/deploy.yaml | oc apply -f -

# Deploy WordPress using normal volume
oc process -p ENV_NAME="test" -f openshift/templates/wordpress-php-fpm/deploy.yaml | oc apply -f -
oc process -p ENV_NAME="test" -f openshift/templates/nginx/deploy.yaml | oc apply -f -
```

# Volume organization and credentials
The current vision for volume organization is that there will be one or more mariadb instances (or "pools"), each with one or more databases.
* Each pool may have multiple databases.
* Each site will have a database with a unique username and password.
* Each pool will have a root username and password which is shared with all its databases.
* A single backup volume can be used for multiple pools.
* Each pool will have its own cron and config.

A potential future problem with this configuration is adding multiple databases with their corresponding credentials.