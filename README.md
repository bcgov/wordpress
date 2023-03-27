![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)

# WordPress Deployments

## Running on Docker
The project can also be run locally using Docker and Docker Compose.  Refer to [Running with Docker](./dev/README.md) for instructions.

## Running on Kubernetes using Kustomize
To deploy on Kubernetes cluster refer to [Deploy with Kustomize](./deployments/kustomize/README.md)

## Running on OpenShift
To deploy using a local instance of OpenShift, refer to [OpenShift Deployment With OpenShift Secrets](./deployments/kustomize/README.md).


## Code of Conduct
Please refer to the [Code of Conduct](./CODE_OF_CONDUCT.md) 

## Contributing
For information on how to contribute, refer to [Contributing](CONTRIBUTING.md)

## License
Code released under the [Apache License, Version 2.0](./LICENSE).

### Todo
* Look into bringing in Wordpress php-fpm-74 not raw php (might have been done this way due to permissions and configurations)
* Look into bring mariadb base image (might have been done this way due to permissions and configurations).
* Implement image  monitoring through dependabot. (DESCW-433)
  * Alpine
  * nginx
  * mariadb
  * WordPress
  * php-fpm
  * ubuntu
  * Add OpenShift Kustomize deploy using Vault secrets
  * Update dev docker instance to deploy on url other than localhost:443 to prevent conflict with Kubernetes cluster

