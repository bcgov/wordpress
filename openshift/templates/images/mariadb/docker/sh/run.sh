#!/bin/sh
set -eo pipefail

touch /tmp/init

# Check if a user is mounting their own config
if [ -z "$(ls -A /etc/my.cnf.d/* 2> /dev/null)" ]; then
  # This needs to be run both for initialization and general startup
  # sed into /tmp/ since the user won't have access to create new
  # files in /etc/
  cp /tmp/my.cnf  /etc/my.cnf.d/
  [ -n "${SKIP_INNODB}" ] || [ -f "/var/lib/mysql/noinnodb" ] &&
    sed -i -e '/\[mariadb\]/a skip_innodb = yes\ndefault_storage_engine = MyISAM\ndefault_tmp_storage_engine = MyISAM' \
        -e '/^innodb/d' /etc/my.cnf.d/my.cnf
fi

MYSQLD_OPTS="--user=mysql"
MYSQLD_OPTS="${MYSQLD_OPTS} --skip-name-resolve"
MYSQLD_OPTS="${MYSQLD_OPTS} --skip-host-cache"
MYSQLD_OPTS="${MYSQLD_OPTS} --skip-slave-start"
# Listen to signals, most importantly CTRL+C
MYSQLD_OPTS="${MYSQLD_OPTS} --debug-gdb"

# No previous installation
if [ -z "$(ls -A /var/lib/mysql/ 2> /dev/null)" ]; then
  [ -z "${MYSQL_ROOT_PASSWORD}" ] && [ -n "${MYSQL_ROOT_PASSWORD_FILE}" ] && MYSQL_ROOT_PASSWORD="$(cat ${MYSQL_ROOT_PASSWORD_FILE} 2> /dev/null)"
  [ -z "${MYSQL_PASSWORD}" ] && [ -n "${MYSQL_PASSWORD_FILE}" ] && MYSQL_PASSWORD="$(cat ${MYSQL_PASSWORD_FILE} 2> /dev/null)"
  [ -n "${SKIP_INNODB}" ] && touch /var/lib/mysql/noinnodb
  [ -n "${MYSQL_ROOT_PASSWORD}" ] && \
    echo "set password for 'root'@'%' = PASSWORD('${MYSQL_ROOT_PASSWORD}');" >> /tmp/init && \
    echo "set password for 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');" >> /tmp/init

  INSTALL_OPTS="--user=mysql"
  INSTALL_OPTS="${INSTALL_OPTS} --cross-bootstrap"
  INSTALL_OPTS="${INSTALL_OPTS} --rpm"
  # https://github.com/MariaDB/server/commit/b9f3f068
  INSTALL_OPTS="${INSTALL_OPTS} --auth-root-authentication-method=normal"
  INSTALL_OPTS="${INSTALL_OPTS} --skip-test-db"
  INSTALL_OPTS="${INSTALL_OPTS} --datadir=/var/lib/mysql"
  eval /usr/bin/mariadb-install-db "${INSTALL_OPTS}"

  if [ -n "${MYSQL_DATABASE}" ]; then
    [ -n "${MYSQL_CHARSET}" ] || MYSQL_CHARSET="utf8"
    [ -n "${MYSQL_COLLATION}" ] && MYSQL_COLLATION="collate '${MYSQL_COLLATION}'"
    echo "create database if not exists \`${MYSQL_DATABASE}\` character set '${MYSQL_CHARSET}' ${MYSQL_COLLATION}; " >> /tmp/init
  fi
  if [ -n "${MYSQL_USER}" ] && [ "${MYSQL_DATABASE}" ]; then
    echo "grant all on \`${MYSQL_DATABASE}\`.* to '${MYSQL_USER}'@'%' identified by '${MYSQL_PASSWORD}'; " >> /tmp/init
  fi
  echo "flush privileges;" >> /tmp/init

  MYSQLD_OPTS="${MYSQLD_OPTS} --init-file=/tmp/init"
  
fi

# make sure directory permissions are correct before starting up
# https://github.com/jbergstroem/mariadb-alpine/issues/54
#chown -R mysql:mysql /var/lib/mysql

eval exec /usr/bin/mysqld "${MYSQLD_OPTS}"
