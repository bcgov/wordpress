ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../"
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
    
# Goes to either the plugin directory or theme directory
gowp() {
	local wptype=${1:-plugins}
	cd $CONTENT_DIR/$wptype
	echo $(pwd)
}

# Searches WordPress ,but excludes certain directories.
wpgrep() {
	echo 'WordPress Grep...'
	grep -rni --color=always --exclude-dir=./node_modules --exclude-dir=./.git --exclude-dir=./vendor --exclude-dir=./dist --exclude-dir=./.phpdocs --exclude-dir=./.audit --exclude-dir=./coverage $@
}