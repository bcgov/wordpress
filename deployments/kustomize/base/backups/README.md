# Backups
In order to restore backups you will need to utilize the sidecar, this needs to be deployed, and the pod needs to be run. See deployment of sidecar for more information.  An additional patch to include the volume mounts for backups and restores will also needed to be added to the deployment.

## Backup Deployment

### Sample Kustomization.yaml overlay for backups

```yaml
# my-wordpress-backups-deploy/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- github.com/bcgov/wordpress/deployments/kustomize/base/backups
# Update to your license plate in the dev|test|prod namespace.
namespace: 123456-dev
images:
  - name: backup-container-mariadb
    newName: image-registry.openshift-image-registry.svc:5000/123456-tools/backup-container-mariadb
    newTag: latest
configMapGenerator:
- name: wordpress-backup-config
  behavior: merge
  literals:
  - BACKUP_DIR=/backups/my-backup-folder/
  - MYSQL_USER=db_user
  # format backup.conf=mariadb={db service}:3306/{db name}
  - backup.conf=mariadb=wordpress-mariadb:3306/db_name
# The Secrets, please update all the secrets.
secretGenerator:
- name: wordpress-backup-secrets
  type: Opaque
  behavior: merge
  literals:
  - MYSQL_PASSWORD=mysqlpassword
```

### Sample overlay patch for sidecar container
This patch is required to mount both the db backups, and file restore container, in order that backup restores of both files and db can be restored.

```yaml
# Patch sidecar to mount the backups.
# my-wordpress-deploy/patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-sidecar
  labels:
    app.openshift.io/runtime: sidecar
spec:
  template:
    spec:
      containers:
      - name: wordpress-sidecar
        volumeMounts:
        - name: wordpress-backup-db
          readOnly: true
          mountPath: /home/sidecar/backups/db
        - name: wordpress-backup-files
          readOnly: true
          mountPath: /home/sidecar/backups/files
      volumes:
      - name: wordpress-backup-db
          persistentVolumeClaim:
            claimName: wordpress-backup-db
       - name: wordpress-backup-files
          persistentVolumeClaim:
            claimName: wordpress-backup-files

```

## Database Backups
* Once this is setup for your environment, there should be no further requirements, except occasionally verification of database being saved.

### Saving DB
* The cron and configurations of the OS CronJob determines the [backup options](https://developer.gov.bc.ca/Backup-Container) of the database.

### Restoring DB
* Use the sidecar, see instructions for deploying the sidecar.
* Both the DB (`/home/sidecar/backups/db`) and the file (`/home/sidecar/backups/files`) backups are mounted in the sidecar.

```bash
# Restore backup db, first gzip (-d) and echo (-c), then pipe into mysql.
gzip -cd ~/backups/db/daily/test.sql.gz | mysql -u $WORDPRESS_DB_USER -p$(cat $MYSQL_PASSWORD_FILE) -h wordpress-mariadb $WORDPRESS_DB_NAME
```

## File Backups within the sidecar
* The `wordpress` pvc (WordPress wp-content folder) uses the ```netapp-file-backup``` storageClassName, which is the same according to [Bcgov OpenShift Storage Solutions Document](https://developer.gov.bc.ca/Persistent-Storage-Services) as the ```netapp-file-standard```
* This is being backed up according to the [OCP4 Backup and Restore Document](https://developer.gov.bc.ca/OCP4-Backup-and-Restore)
    * As of the time of this writing it does full backups monthly, incremental backups daily, and retained for 90 days.
* A manual backup can be done by ```rsync -a /var/www/html/wp-content/ /home/sidecar/backups/files/```
 
### Restoring file backups
* Request for backup as per [OCP4-Backup-and-Restore Document](https://developer.gov.bc.ca/OCP4-Backup-and-Restore)
    * https://github.com/BCDevOps/devops-requests/issues - add an issue, in the future there might be a template for this request.
* And request it uses pvc **wordpress-backup-files**, and use a subfolder `/restore`
* Once files are in the restore folder, update the root folder `/home/sidecar/backups/files` with contents of the `/restore` folder
* Ensure the files to be restored is in the `/home/sidecar/backups/files`
* Switch from regular volume to backup volume as indicated below. (Your Instance is now using the backup volume, this is only temporary)  
* Use the sidecar, see instructions for deploying the sidecar.
* Do a ```rsync -a --exclude=restore /home/sidecar/backups/html/ /var/www/html/wp-content``` 
    * you might have to delete the files in /var/www/html, but **WARNING** make sure you know what you are doing.
* Switch from backup volume to regular volume as indicated below, so now WordPress should be using restored files.