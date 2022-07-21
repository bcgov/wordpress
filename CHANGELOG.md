# Changelog

## Jul 20, 2022(DESCW(469))

- Bump nginx to version 1.23.1

## Jul 13, 2022 (DESCW(470))

- Disable dependabot automatic pull requests.

## June 29, 2022 (DESCW(443))

- Move php config into wordpress docker build.
- Move mariadb config into mariadb docker build.
- Move nginx config into nginx docker build.

## June 28, 2022 (DESCW(433))

- Dependabot monitoring for docker images.

## June 16, 2022 (DESCW-424)

- Triggers in deployments for image updates.
- updating variable naming so an `env | grep -i oc_` can show all the variables.
- Fixing backup configuration refs
- Fixed mariadb volume mount to readwritemany as this volume is used for multiple databases.
- combined configurations.
