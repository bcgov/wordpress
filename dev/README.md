# WordPress Local Development

## Setting Up from Scratch

### Step 1: Environment Basics
* Rename `sample-env` file to `.env`
* Update variables inside `.env` file to fit your needs. The defaults are probably ok.

### Step 2: Setting up SSL on Mac (required)
* ```docker compose --file docker-compose-init.yaml run self-signed-certificate-generator``` sets up self signed certs.
* Drag ./Docker/nginx/ssl/localhost.crt to keychain app (login) section and trust always:
  * Double-click the certificate.
  * Next to Trust, click the arrow and in the dropdown box for "When using this certificate:" select `Always Trust`.

### Step 3: Pre Build php-74-fpm
* `docker build -t wordpress-php-fpm-build:dev openshift/templates/images/php74-fpm/docker`

### Step 4: Run Docker compose
* `docker compose up`

### Step 5: optional multi-site:
* In the WordPress admin UI, go to menu Tools -> Network Setup and click install
* Bring down the WordPress site ```docker compose stop``` (or \<CTRL>-C if docker is in the foreground).
* In your `.env` file, ensure
  * ```MULTISITE=true```
  * ```SITE_ID=1```
* Bring up WordPress site ```docker compose start``` or ```docker compose up```
* In the WordPress admin UI, go to My Sites -> Network Admin -> Settings and change Max upload file size to 10000


### Running Thereafter:
* ```docker compose up``` runs the nginx, db, and WordPress containers, this will also output debug.log in the stdout.

* Plugins ,themes, and uploads, can be found at the path specified in your `.env` under variable `PLUGIN_DIR`, `THEME_DIR`, `UPLOADS_DIR` respectively.