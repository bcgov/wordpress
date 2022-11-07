# WordPress Image

[Back to images](../README.md)

## Updating WordPress Core
* Get [WordPress official image](https://hub.docker.com/_/wordpress) and verify the version exists.
* Update [Image stream reference](https://github.com/bcgov/wordpress/blob/main/openshift/templates/dockerhub-imagestreams/wordpress.yaml#L36) to new version of the WordPress official image.  -- **Is this step needed**
* Add new WordPress official image to OpenShift `oc process -f openshift/templates/dockerhub-imagestreams/wordpress.yaml | oc apply -f -` -- **Is this step needed**
* Update [Dockerfile](https://github.com/bcgov/wordpress/blob/main/openshift/templates/images/wordpress/docker/Dockerfile#L1) to reference new version of WordPress core 
* Check build of new image locally, see **Building Locally**
* Update WordPress image references in the [Image Version Table](https://github.com/bcgov/wordpress/blob/main/openshift/templates/README.md)
* Update the CHANGELOG.md
* Commit changes, complete Pull Request, and, merge into `Main` after approval
  * This will then generate an openshift build using a [github action](https://github.com/bcgov/wordpress/blob/main/.github/workflows/wordpress-build.yaml) to rebuild the WordPress core image.

## Building Locally
* Build new image `docker build -t wordpress-wordpress-run:dev -f openshift/templates/images/wordpress/docker/Dockerfile ./openshift/templates/images/wordpress/docker`
* Verify new image `docker run -it wordpress-wordpress-run:dev grep -rni wp_version /usr/src/wordpress/wp-includes/version.php`
* This should then output the latest WordPress version.

## Deploy to Dev
*  Once a change has been made to the WordPress docker image, and the code has been merged into the `main` branch, a github action creates a `wordpress-wordpress-run:dev` imagestream from the `wordpress-wordpress-run` Build -> BuildConfigs in OpenShift tools namespace.
*  Verify this build has been created in the tools namespace `wordpress-wordpress-run` ImageStream
*  In order for any WordPress instance in the `dev` namespace environment to get updated, the WordPress pods have to be terminated.


## Deploy to Test
* In the tools namespace run the following command `oc tag wordpress-wordpress-run:dev wordpress-wordpress-run:test`  
* In order for any WordPress instance in the `test` namespace environment to get updated, the WordPress pods have to be terminated.

## Deploy to Production
* In the tools namespace run the following command `oc tag wordpress-wordpress-run:test wordpress-wordpress-run:{wp version}`  - this tag can then be used to go back to a specific version.
* In the tools namespace run the following command `oc tag wordpress-wordpress-run:test wordpress-wordpress-run:prod`  
*  In order for any WordPress instance in the `prod` namespace environment to get updated, the WordPress pods have to be terminated.
*  **CAUTION** These are production sites.