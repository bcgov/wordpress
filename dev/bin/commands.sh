#!/usr/bin/env bash 
ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../"
# Accomodate zsh
if [ ! -f "$ROOT_PATH/.env" ]; then 
    ROOT_PATH="$(dirname $(readlink -f $0))/../"
fi
# Load in the env file
source "$ROOT_PATH.env"

# Tails the WordPress Logs
wp_log() {
    tail -f $CONTENT_DIR/debug.log | cut -b 1-10000
}

# Starts the WordPress local development
wp_start() {
    cd $ROOT_PATH
    docker compose up $@
}

# Stops the WordPress local development
wp_stop() {
    cd $ROOT_PATH
    docker compose down
}

# Access to the WordPress cli
wp() {
    #cd $ROOT_PATH
    # gets any container that has the image of wordpress:cli-php7.4, so wp cli can be ran on any developer instance
    docker exec -it $(docker ps --filter "ancestor=wordpress:cli-php7.4" --format "{{.Names}}") wp $@
}

# Audit plugins or themes
wp_audit() {
    source "${ROOT_PATH}bin/wpaudit.sh"
}

# Set up WordPress unit testing environment
wp_setup_tests() {
    docker exec -it dev-wordpress-php-fpm-1 /bin/sh -c "/usr/bin/setup-tests.sh wordpress_test root ${MYSQL_ROOT_PASSWORD} ${MYSQL_HOST}"
}

# Perform WordPress PHP unit tests on the current directory
# Should be used from a theme or plugin project's root
wp_test() {
    docker exec \
    -w /var/www/html/wp-content/${PWD//$CONTENT_DIR/} \
    -it dev-wordpress-php-fpm-1 \
    vendor/bin/phpunit --configuration vendor/bcgov/wordpress-utils/phpunit.xml.dist
}
    
# Goes to either the plugin directory or theme directory
gowp() {
	local wptype=${1:-plugins}
	cd $CONTENT_DIR/$wptype
	echo $(pwd)
}

# php composer docker instance https://hub.docker.com/_/composer
wp_composer() {
    docker run --rm --interactive --tty \
    --volume $PWD:/app \
    composer:latest $@
}

# Searches WordPress ,but excludes certain directories.
wpgrep() {
	echo 'WordPress Grep...'
	grep -rni --color=always --exclude-dir=./node_modules --exclude-dir=./.git --exclude-dir=./vendor --exclude-dir=./dist --exclude-dir=./.phpdocs --exclude-dir=./.audit --exclude-dir=./coverage $@
}