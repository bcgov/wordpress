#!/bin/bash
set -e

ID=`id -u`
sed -i 's/:12358:/:'"$ID"':/g' /etc/passwd

if [ "$HOME" == "/" ]; then
	export HOME="/home/sidecar"
fi

exec "$@"
