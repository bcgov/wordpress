# Deployment WordPress
*All commands are given from root of the repository.

## Deprecated OpenShift Template Deployments
**Warning**  Use of the OpenShift templates including image builds and deployments will be deprecated in favour of using Kustomize deployments.  Refer to [OpenShift Template Deployment](https://github.com/bcgov/wordpress/tree/bb8fd6066bcc2087605c50f941b8b906dc0e9b61/openshift/templates)


## Local Deployment with Docker
[Deploying WordPress with Docker Compose](../../dev/README.md)

## Local Deployment with Kubernetes and Kustomize

### Set local kubernetes context
Assuming you have rancher desktop installed, you might have different contexts, especially if you deploy OpenShift applications.

* To get a list of all contexts you can run ```kubectl config get-contexts```
* If you are deploying locally then you will want to set your context, if not already set. Lets assume our local context is rancher-desktop.
* Set context ```kubectl config use-context rancher-desktop```
  * If successful you should see something like:
  * `Switched to context "rancher-desktop"`

### Deploy with Kustomize
* [Kustomize](https://kubectl.docs.kubernetes.io/) is a standalone tool to customize Kubernetes objects through a kustomization file, that ships with both OC and kubectl deployment utilities.
* To make local deployments more seamless, all images are being pulled from DockerHub [bcgovgdx namespace](https://hub.docker.com/?namespace=bcgovgdx).
* These images should **NOT** be used in production deployments.
* Prerequisites
  * Kubernetes cluter 
  * Kubectl installed
* Deploy using ```kubectl apply -k ./deployments/kustomize/overlays/local```
* **Delete** CAUTION - This will delete all resources.
  * ```kubectl delete -k ./deployments/kustomize/overlays/local```
* Your new site should be accessible at http://0.0.0.0:30080/ 
* WordPress networks can't be used due to the port restrictions.

#### Access the sidecar
* Find the sidecar pod by running ```kubectl get pods``` then replace the pod name in the command.
* ```kubectl exec -it  pod/wordpress-sidecar-abcd -- bash```
* cd /var/www/html
* you can now run [wp cli](https://wp-cli.org/) commands, however locally this container is running in root so you will have to use the --allow-root flag
* sample command ```wp plugin list --allow-root```


## OpenShift Deployment With OpenShift Secrets

### Deploying images to tools.
* In order for deployments in openshift to work, you will have to generate your own overlay which will point to the `./deployments/kustomize/overlays/openshift/Images` folder of this repo.

#### Sample Overlay for Image deployment in tool namespace
```yaml
# my-image-deploy/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
# Points to the overlay that creates the images.
resources:
- github.com/bcgov/wordpress/deployments/kustomize/overlays/openshift/images
# Update to your license plate in the tools namespace.
namespace: 123456-tools
```

#### Sample Overlay for WordPress deployment to dev namespace
```yaml
# my-wordpress-deploy/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
# Points to the overlay that creates the images.
resources:
- github.com/bcgov/wordpress/deployments/kustomize/overlays/openshift
# Update to your license plate in the dev|test|prod namespace.
namespace: 123456-dev
images:
  - name: wordpress-mariadb-run
    newName: image-registry.openshift-image-registry.svc:5000/123456-tools/wordpress-mariadb-run
    newTag: dev
  - name: wordpress-wordpress-run
    newName: image-registry.openshift-image-registry.svc:5000/123456-tools/wordpress-wordpress-run
    newTag: dev
  - name: wordpress-nginx-run
    newName: image-registry.openshift-image-registry.svc:5000/123456-tools/wordpress-nginx-run
    newTag: dev
  - name: wordpress-sidecar-run
    newName: image-registry.openshift-image-registry.svc:5000/123456-tools/wordpress-sidecar-run
    newTag: dev
configMapGenerator:
- name: wordpress-config
  behavior: merge
  literals:
  - APP_DOMAIN=my-wordpress-url.com
# The Secrets, please update all the secrets.
secretGenerator:
- name: wordpress-secrets
  type: Opaque
  literals:
  - MYSQL_PASSWORD=mysqlpassword
  - MYSQL_ROOT_PASSWORD=rootmysqlpassword
  - WORDPRESS_AUTH_KEY=authkey
  - WORDPRESS_SECURE_AUTH_KEY=secureauthkey
  - WORDPRESS_LOGGED_IN_KEY=loggedinkey
  - WORDPRESS_NONCE_KEY=noncekey
  - WORDPRESS_AUTH_SALT=authsalt
  - WORDPRESS_SECURE_AUTH_SALT=secureauthsalt
  - WORDPRESS_LOGGED_IN_SALT=loggedinsalt
  - WORDPRESS_NONCE_SALT=noncesalt
patchesStrategicMerge:
- patch.yaml
```

#### Sample WordPress Deploy overlay Patch file.
```yaml
# my-wordpress-deploy/patch.yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: wordpress-nginx
spec:
  host: my-wordpress-url.com
```

### Deploying images and WordPress deployment using overlays
* Deploy your images to OpenShift ```oc apply -k my-image-deploy```
  * Deploying the images, will not trigger a build, this has to be done manually in OpenShift.
* Deploy WordPress to OpenShift ```oc apply -k my-wordpress-deploy```
* Visit your site at my-wordpress-url.com to finish the installation.
* At this point there will be no single sign on, this can be accomplished using WordPress plugins, and a SSO service.


## OpenShift Deployment with Vault Secrets
Contact Digital Engagement Solutions Custom Web Team.

## Image versions

| Image | Version | Description |
| ----- | ------- | ----------- |
| alpine | 3.15.4 | Base Alpine linux |
| mariadb | 10.6.8-r0 | MariaDB version that gets build in base-images via Dockerfile. Dependent on the [Alpine version](https://pkgs.alpinelinux.org/packages?name=mariadb&branch=v3.15): |
| nginx | 1.23.1-alpine | Nginx web server, used to serve WordPress / PHP |
| wordpress | 6.1.1-php7.4-fpm-alpine | PHP-FPM for WordPress |
| ubuntu | 22.04| Used for the sidecar |