# Changelog

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
