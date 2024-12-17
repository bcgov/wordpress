# Deploying WordPress to Kubernetes


[Kustomize](https://kubectl.docs.kubernetes.io/) is a standalone tool to customize Kubernetes objects through a kustomization file, that ships with both OC and kubectl deployment utilities.
To make local deployments more seamless, all images are being pulled from DockerHub [bcgovgdx namespace](https://hub.docker.com/?namespace=bcgovgdx), alternatively you can [build this images using docker build](#building-images)
  

## Prerequisites
* Kubernetes cluster 
* Kubectl installed
## Deploy
```sh:no-line-numbers
kubectl apply -k ./deployments/kustomize/overlays/local
```

## The Deployment
* Your new site should be accessible at http://0.0.0.0:30080/ 
* WordPress network sites can't be used due to the port restrictions.

### Access the sidecar
* Find the sidecar pod by running ```kubectl get pods``` then replace the pod name in the command.
* ```kubectl exec -it  pod/wordpress-sidecar-abcd -- bash```
* cd /var/www/html
* you can now run [wp cli](https://wp-cli.org/) commands, however locally this container is running in root so you will have to use the --allow-root flag
* sample command ```wp plugin list --allow-root```
  

## Delete Deployment
```sh:no-line-numbers
kubectl delete -k ./deployments/kustomize/overlays/local
```
::: warning
This will delete all resources, including volumes
:::

## Building Images

### Nginx
```sh:no-line-numbers
# Build the image
docker build -t bcgovgdx/wordpress-nginx-run \
            -f openshift/templates/images/nginx/docker/Dockerfile \
            ./openshift/templates/images/nginx/docker

# Verify image
docker run -it bcgovgdx/wordpress-nginx-run sh
```

### MariaDB
```sh:no-line-numbers
# Build the image
docker build -t bcgovgdx/wordpress-mariadb-run \
            -f openshift/templates/images/mariadb/docker/Dockerfile \
            ./openshift/templates/images/mariadb/docker
```

### WordPress
```sh:no-line-numbers
# Build the image
docker build -t bcgovgdx/wordpress-wordpress-run \
            -f openshift/templates/images/wordpress/docker/Dockerfile \
            ./openshift/templates/images/wordpress/docker
```

### Sidecar
```sh:no-line-numbers
# Build the image
docker build -t bcgovgdx/wordpress-sidecar-run \
            -f openshift/templates/images/sidecar/docker/Dockerfile \
            ./openshift/templates/images/sidecar/docker
```

### Plugin / themes
```sh:no-line-numbers
# Build the image
docker build -t bcgovgdx/wordpress-plugins-themes \
            -f openshift/templates/images/plugins_themes/Dockerfile \
            ./openshift/templates/images/plugins_themes/
```

::: warning
Images that come from [bcgovgdx namespace](https://hub.docker.com/search?q=bcgovgdx) should **NOT** be used in production deployments.
:::

::: tip
All commands are given from the root of this repository
:::