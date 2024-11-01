# OpenShift uses version from buildconfig - Don't update
FROM alpine:3.20

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.title="mariadb-alpine" \
  org.opencontainers.image.description="A MariaDB container suitable for development" \
  org.opencontainers.image.authors="Johan Bergström <bugs@bergstroem.nu>" \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.source="https://github.com/jbergstroem/mariadb-alpine" \
  org.opencontainers.image.url="https://github.com/jbergstroem/mariadb-alpine" \
  org.opencontainers.image.schema-version="1.0.0-rc.1" \
  org.opencontainers.image.license="MIT"

SHELL ["/bin/ash", "-euo", "pipefail", "-c"]

# Mariadb versions are here: https://pkgs.alpinelinux.org/packages?name=mariadb&branch=v3.20&repo=&arch=x86_64&origin=&flagged=&maintainer=
RUN \
  apk add --no-cache mariadb && \
  TO_KEEP=$(echo " \
    usr/bin/mysql$ \
    usr/bin/mysqld$ \
    usr/bin/mariadb$ \
    usr/bin/mariadbd$ \
    usr/bin/getconf$ \
    usr/bin/getent$ \
    usr/bin/my_print_defaults$ \
    usr/bin/mariadb-install-db$ \
    usr/share/mariadb/charsets \
    usr/share/mariadb/english \
    usr/share/mariadb/mysql_system_tables.sql$ \
    usr/share/mariadb/mysql_performance_tables.sql$ \
    usr/share/mariadb/mysql_system_tables_data.sql$ \
    usr/share/mariadb/maria_add_gis_sp_bootstrap.sql$ \
    usr/share/mariadb/mysql_sys_schema.sql$ \
    usr/share/mariadb/maria_add_gis_sp_bootstrap.sql$ \
    usr/share/mariadb/fill_help_tables.sql$" | \
    tr -d " \t\n\r" | sed -e 's/usr/|usr/g' -e 's/^.//') && \
  INSTALLED_FILES="$(apk info -q -L mariadb-client | tail -n +2) \
  $(apk info -q -L mariadb-common | tail -n +2) \
  $(apk info -q -L mariadb | tail -n +2)" && \
  for path in $(echo "${INSTALLED_FILES}" | grep -v -E "${TO_KEEP}"); do \
    echo "deleting ${path}"; \
    eval rm -rf "${path}"; \
  done && \
  touch /usr/share/mariadb/mysql_test_db.sql && \
  # allow anyone to connect by default
  sed -i -e 's/127.0.0.1/%/' /usr/share/mariadb/mysql_system_tables_data.sql && \
  mkdir -p /run/mysqld /var/lib/mysql && \
  sed -i 's/\(mysql:x:\)[0-9]*:[0-9]*:/\1'"1001"':'"0"':/' /etc/passwd && \
  sed -i 's/chown \$user \$dir/echo "No Change for Openshift"/' /usr/bin/mariadb-install-db && \
  sed -i 's/chmod 700 \$dir//' /usr/bin/mariadb-install-db && \
  chown 1001:0 /etc/my.cnf.d/ /run/mysqld /var/lib/mysql /usr/share/mariadb/mysql_system_tables_data.sql && \
  chmod 770 /var/lib/mysql /run/mysqld /etc/my.cnf.d

# The one installed by MariaDB was removed in the clean step above due to its large footprint
COPY sh/resolveip.sh /usr/bin/resolveip
COPY sh/run.sh /run.sh
# Used in run.sh as a default config
COPY my.cnf /tmp/my.cnf

# This is not super helpful; mysqld might be running but not accepting connections.
# Since we have no clients, we can't really connect to it and check.
#
# Below is in my opinion better than no health check.
HEALTHCHECK --start-period=5s CMD pgrep mysqld

VOLUME ["/var/lib/mysql"]
ENTRYPOINT ["/run.sh"]
EXPOSE 3306

USER 1001
