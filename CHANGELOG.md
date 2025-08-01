# Changelog
### July 29, 2025
- ([DESCW-3086](https://citz-gdx.atlassian.net/browse/DESCW-3086))
  - update permissions for the sidecar workflow
  - Add required permissions to workflows for GitHub Actions to function correctly
  - Fixed some Issues with the workflow syntax and formatting
  - added helpful comments to the workflow files
  - enabled manual triggering of the workflows
  - renamed deploy_ghpages.yml to ghpages.yaml for consistency with other workflows

### May 16, 2025
- ([DESCW-3022](https://citz-gdx.atlassian.net/browse/DESCW-3022))
  - update WordPress from 6.7.1 - 6.8.1
  - update WordPress CLI from 2.7.1 -> 2.12.0
  - update Nginx from 1.26.2 -> 1.27.5

### April 4, 2025
- improve workflow for wp-cli container ([DESCW-2977](https://citz-gdx.atlassian.net/browse/DESCW-2977))

### February 21, 2025
- Increase nginx `client_max_body_size` for port 38080 (used by NaadConnector/EEWS)

### January 16, 2025
- updating Code owners file, to configure requirements of code owner decision ([DESCW-2805](https://citz-gdx.atlassian.net/browse/DESCW-2805))

### December 16, 2024
- update WordPress version to 6.7.1 ([DESCW-2837](https://citz-gdx.atlassian.net/browse/DESCW-2837))

### December 2, 2024
- allow access for WordPress local dev from within a local container ([DESCW-2657](https://citz-gdx.atlassian.net/browse/DESCW-2657))
- removed $ROOT_PATH from wp command as it gave undesired results, and not required.

### November 1, 2024
- update plugin/theme deployments ([DESCW-2691](https://citz-gdx.atlassian.net/browse/DESCW-2691))
- update images ([DESCW-2689](https://citz-gdx.atlassian.net/browse/DESCW-2689))
  - update WordPress deploy image  wordpress:6.4.2-php8.3-fpm-alpine - wordpress:6.6.2-php8.3-fpm-alpine
  - update Nginx deploy image 1.25.3 - 1.26.2
  - update alpine deploy image 3.18.4 - 3.20.3 (mariadb v)
### May 2, 2024
- Integrate reusable unit tests by adding resulable functionality to test commands. ([DESCW-2664](https://citz-gdx.atlassian.net/browse/DESCW-2664))
-
## May 31, 2024
- Updated dev deployment to allow WordPress unit tests to be run inside the PHP Wordpress container.
- Created two new commands to support the above:
  - `wp_setup_tests`: Runs the WP-provided script to install test files and set up the test database.
  - `wp_test`: Runs unit tests on the current directory.
- **NOTE:** Run `docker compose down` and `docker compose up --build` to get these changes if you already have this deployment running.

## February 29, 2024
- Updated local WordPress Deployment
  - auto updates 3rd party plugins to minor versions.
  - checks to see if cores is at latest version
  - lists sites in the stdout for docker compose up
  - backups entire database to /tmp/WordPress -> ~/tmp/WordPress (default)
- Add a `wp_composer` command which equals composer:latest https://hub.docker.com/_/composer

## February 12, 2024
- Update VuePress dependencies (DESCW-1926)

## January 8, 2024
- update codeowners and dependabot to digital-engagement-solutions-custom-web team

## January 3, 2024
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
