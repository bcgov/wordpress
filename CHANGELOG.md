# Changelog
## January 8, 2023
- update codeowners and dependabot to digital-engagement-solutions-custom-web team


## January 3, 2023 
- updated WorPress 6.4.2, and upgraded PHP 8.0 -> 8.3 as 6.4.2 no longer supports PHP 8.0 (DESCW-1872)
- update plugins_themes php 8.0 -> 8.3
- remove namespace from volume and job in base plugin_themes deployment (DESCW-1429)

## November 30, 2023 (DESCW-1771)
- moved image_builds from deployments/kustomize/overlays/openshift -> deployments/kustomize to be consistent with other repositories.
- documentation update.
- all image versions are now only changed at the build configs, not at the Dockerfile
- removed mariadb-server-utils from sidecar build, as this package doesn't exists.


## November 24, 2023 (DESCW-1677)
- Added documentation for manually backing up or copying a site.

## November 1, 2023 (DECW-1559)
- Added vuepress documentation boiler plate
- Added github workflows to publish to gh_pages

## October 26, 2023
- Removed plugins-themes volume from the plugins_themes kustomize deployment to avoid deleting it when using oc delete -k

## October 11, 2023 (DESCW-1534)
- Update Alpine to 3.18.4
- Add mariadb-server-utils to sidecar

## October 05, 2023 (DESCW-1534)
- Update wordpress to 6.3.1.

## September 25, 2023 (DESCW-1536)
- Fixed vendor dependency loads.
- Fixed issues with plugin/theme resources not being rendered
## September 07, 2023 (DESCW-1465)
- Fixed wrong option name (max_post_size) in php.conf.ini
## August 17, 2023 (DESCW-1428)
- update wordpress to 6.3.0
## June 14, 2023 (DESCW-1237)
- Fixed volume config map for the mariadb backup cronjob, which was causing the backup job to fail.

## June 8, 2023 (DESCW-1189)
- update wordpress to 6.2.2
- fix bug caused by redhat dependency update
## May 09, 2023 (DESCW-1065)
- Update github openshift actions to use node16 instead of deprecated 12.
## May 09, 2023 (DESCW-985)
- Add plugins-themes deployment job to install plugins and themes to shared persistent volumes for dev and test environments.

## April 21, 2023 (DESCW-1014)
- Update WordPress version 6.2, and updated PHP version to 8.0 from 8.2 as this is more widely supported by plugins and themes.

## April 20, 2023 (DESCW-1014)
- Update WordPress version 6.2, and updated PHP version to 8.2 from 7.4
- Update WordPress image build config name to just wordpress

## April 6, 2023 (DESCW-971)
- Backups are now using Kustomize, with updated documentation.

## March 27, 2023 (DESCW-981)
- Adding Kustomize base deployments for local Kubernetes, and OpenShift deployments.
- Removed all referenced to OpenShift deployments, except backups, as they still need to be included with the OpenShift Kustomize deployments.
- Referenced to [OpenShift Template Deployments](https://github.com/bcgov/wordpress/tree/bb8fd6066bcc2087605c50f941b8b906dc0e9b61/openshift/templates) in case the reference is still required

## March 02, 2023 (DESCW-972)
- Removed specific mariadb version from image build to prevent it from failing whenever the alpine package is updated.

## February 7, 2023 (N/A)
- added audit utility
- updated commands.sh to be compatible with .zsh shell

## December 15 2022 (DESCW-716)
- Upgrade wordpress to use v6.1.1

## November 23 2022 (N/A)
- Added PHPMyAdmin container to docker-compose.yaml
- Updated README

## November 02 2022 (DESCW-592)
- Upgrade wordpress to use v6.0.3

## September 15 2022 (DESCW-593)
- Upgrade wordpress to use v6.0.2

## July 27, 2022 (DESSO-467)
- Fixed Nginx config directory
- Added nginx.conf configmap mount for nginx site specific overrides.

## Jul 21, 2022(DESCW-469)
- Bump nginx to version 1.23.1
- Add reference locations for images in openshift templates README.

## Jul 13, 2022 (DESCW-470)
- Disable dependabot automatic pull requests.

## June 29, 2022 (DESCW-443)
- Move php config into wordpress docker build.
- Move mariadb config into mariadb docker build.
- Move nginx config into nginx docker build.

## June 28, 2022 (DESCW-433)
- Dependabot monitoring for docker images.

## June 16, 2022 (DESCW-424)
- Triggers in deployments for image updates.
- updating variable naming so an `env | grep -i oc_` can show all the variables.
- Fixing backup configuration refs
- Fixed mariadb volume mount to readwritemany as this volume is used for multiple databases.
- combined configurations.
