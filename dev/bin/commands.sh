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
    cd $ROOT_PATH
    docker exec -it dev-wp-cli-1 wp $@
}

# Audit plugins or themes
wp_audit() {
    source "${ROOT_PATH}bin/wpaudit.sh"
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