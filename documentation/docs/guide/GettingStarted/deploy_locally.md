---
title: Local development with WordPress
description: Setup process for local development of Wordpress using Docker.
---

# Deploying WordPress to Docker

## Setup
Clone this repository, and go to the dev directory
```sh:no-line-numbers
# Clone WordPress deployment repository
git clone https://github.com/bcgov/wordpress.git
# Change directory to the wordpress/dev folder
cd wordpress/dev
# Create an .env by copying the sample .env
cp sample-env .env
```

## Environment Basics
* Update variables inside `.env` file to reflect your setup. 
  * The `CONTENT_DIR` variable is the location of your WordPress content directory.
  * The `TEMP_DIR` variable can be used to import/export db using the wp-cli command.
::: tip
When Importing and Exporting databases with the `wp cli` This will be the link between the WordPress container and your local machine.
:::

## Setting up SSL on Mac (required)
```sh:no-line-numbers
# sets up `localhost` self signed certs.
docker compose --file docker-compose-init.yaml run self-signed-certificate-generator
``` 

* Drag ./Docker/nginx/ssl/localhost.crt to KeyChain app (login) section and trust always:
  * Double-click the certificate.
  * Next to Trust, click the arrow and in the dropdown box for "When using this certificate:" select `Always Trust`.
* If this cert is not working, try restarting your MAC, however there might be a less drastic way of making this work.

::: warning
WordPress will now run on localhost port 443, which is exactly the same port that Kubernetes runs on.  Therefore local Kubernetes and WordPress can't be running at the same time.
:::

<img src="/images/keychain-localhost.png" style="max-width:250px;margin: 1rem 0"/>

## Run Docker compose
::: warning
You have to be in the wordpress/dev directory for this to work
:::
```sh:no-line-numbers
# Starts WordPress deployment 
docker compose up
# to re-build the images and start WordPress deployment
# The build flag is required, anytime there are changes to the images.
docker compose up --build
# If you enable build in shell scripts, this scripts works from anywhere
# Starts WordPress deployments
wp_start
```

* Access Wordpress at [https://localhost](https://localhost)
* Access PHPMyAdmin at [http://localhost:8081](http:/localhost:8081) (Note: does not use https)

## Optional multi-site (Recommended):
* In the WordPress admin UI, go to menu Tools -> Network Setup and click install
* Bring down the WordPress site ```docker compose down``` (or \<CTRL>-C if docker is in the foreground and then `docker compose down`).
* In your `.env` file, ensure
  * ```MULTISITE=1```

* Bring up WordPress site `docker compose up` 
* In the WordPress admin UI, go to My Sites -> Network Admin -> Settings and `change Max upload file size` to 10000 and click `Save Changes`

<img src="/images/max-upload-file-size.png" style="max-width:250px;margin: 1rem 0"/>

## Running Thereafter:
* ```docker compose up``` runs the nginx, db, WordPress php-fpm, and wp-cli containers, this will also output debug.log in the stdout.

* WordPress wp-content directory, can be found at the path specified in your `.env` under variable `CONTENT_DIR`, .

## Helper functions.
The [Helper functions](./bin/commands.sh) can be linked to run anytime a new terminal window is open by adding it to your `~/.bash_profile` 

### Including helper functions in bash profile.
::: tip
In order to make the helper functions accessible you need to include them into your bash or zsh profile.  These commands then can be run from anywhere on your file system from a terminal window.
:::

If you are using bash add this to your `~/.bash_profile`
```bash
if [ -f /location-of-this-repo/wordpress/dev/bin/commands.sh ] ; then
 . /location-of-this-repo/wordpress/dev/bin/commands.sh
fi
 ```
 Once this is done you can use the following commands from any directory
 * `wp_start` - Starts WordPress local deployment (docker)
 * `wp_stop` - Stops WordPress local deployment (docker)
 * `wp_log` - Tails the debug.log in the content directory
 * `gowp` - Goes to plugin directory
 * `gowp themes` - Goes to themes directory
 * `wpgrep` - Does a grep with certain excludes to directories like .git, node_modules, vendor
 * `wp` - [Wordpress Command line](https://wp-cli.org/) that allows an endless amount of things to be completed with your local WordPress instance.


## Example WordPress Command Line using wp.
* `wp site list` - Shows all the sites.
* `wp plugin list` - gets all the plugins.
* `wp plugin update akismet` - updates akismet plugin

## Backing up full database
This file will get stored in a directory that you determined in your `.env` as the `TEMP_DIR` variable.
```sh:no-line-numbers
# In order for this command to work you need the following in your terminal profile (bash or zsh)
# . /location-of-this-repo/wordpress/dev/bin/commands.sh as shown above
wp db export /tmp/WordPress/all-sites.sql --add-drop-table
```
## Restoring full database
::: warning
This command will replace your entire database, before running `wp db import` make sure you understand what this command does.
:::
```sh:no-line-numbers
wp db import /tmp/WordPress/all-sites.sql
```
