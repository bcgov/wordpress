# WordPress Local Development

## Step 1: Environment Basics
* Copy `sample-env` file to `.env`
* Update variables inside `.env` file to reflect your setup. 
  * The `CONTENT_DIR` variable is the location of your WordPress content directory.
  * The `TEMP_DIR` variable can be used to import/export db using the wp-cli command.

## Step 2: Setting up SSL on Mac (required)
* ```docker compose --file docker-compose-init.yaml run self-signed-certificate-generator``` sets up `localhost` self signed certs.
* Drag ./Docker/nginx/ssl/localhost.crt to KeyChain app (login) section and trust always:
  * Double-click the certificate.
  * Next to Trust, click the arrow and in the dropdown box for "When using this certificate:" select `Always Trust`.
* If this cert is not working, try restarting your MAC, however there might be a less drastic way of making this work.

<img src="./assets/keychain-localhost.png" style="max-width:250px;margin: 1rem 0"/>

## Step 3: Run Docker compose
* `docker compose up` or `docker compose up --build` to rebuild all the images.
  * The build flag is required, anytime there are changes to the images.
* Access Wordpress at https://localhost
* Access PHPMyAdmin at http://localhost:8081 (Note: does not use https)

## Step 4: Optional multi-site (Recommended):
* In the WordPress admin UI, go to menu Tools -> Network Setup and click install
* Bring down the WordPress site ```docker compose down``` (or \<CTRL>-C if docker is in the foreground and then `docker compose down`).
* In your `.env` file, ensure
  * ```MULTISITE=1```

* Bring up WordPress site `docker compose up` 
* In the WordPress admin UI, go to My Sites -> Network Admin -> Settings and `change Max upload file size` to 10000 and click `Save Changes`

<img src="./assets/max-upload-file-size.png" style="max-width:250px;margin: 1rem 0"/>

## Running Thereafter:
* ```docker compose up``` runs the nginx, db, WordPress php-fpm, and wp-cli containers, this will also output debug.log in the stdout.

* WordPress wp-content directory, can be found at the path specified in your `.env` under variable `CONTENT_DIR`, .

## Helper functions.
The [Helper functions](./bin/commands.sh) can be linked to run anytime a new terminal window is open by adding it to your `~/.bash_profile` 

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
* `wp db export /tmp/WordPress/all-sites.sql --add-drop-table` - used to backup or save all the sites to your `TEMP_DIR`
