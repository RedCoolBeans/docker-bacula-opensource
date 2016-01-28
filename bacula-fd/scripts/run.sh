#!/bin/bash

: ${BACULA_DEBUG:="50"}
: ${LOG_FILE:="/opt/bacula/log/bacula.log"}
: ${DIR_NAME:="bacula"}
: ${MON_NAME:="bacula"}
: ${FD_NAME:="bacula"}

# Only one variable is required, FD_PASSWORD. MON_FD_PASSWORD is derived from it.
if [ -z "${FD_PASSWORD}" ]; then
	echo "==> FD_PASSWORD must be set, exiting"
	exit 1
fi

: ${MON_FD_PASSWORD:="${FD_PASSWORD}"}

CONFIG_VARS=(
  FD_NAME
  FD_PASSWORD
  DIR_NAME
  MON_NAME
  MON_FD_PASSWORD
)

cp /opt/bacula/etc/bacula-fd.conf.orig /opt/bacula/etc/bacula-fd.conf
for c in ${CONFIG_VARS[@]}; do
  sed -i "s,@@${c}@@,$(eval echo \$$c)," /opt/bacula/etc/bacula-fd.conf
done

# echo "==> Verifying Bacula FD configuration"
# /opt/bacula/bin/bacula-fd -c /opt/bacula/etc/bacula-fd.conf -t

echo "==> Starting Bacula FD"
/opt/bacula/bin/bacula-fd -c /opt/bacula/etc/bacula-fd.conf -d ${BACULA_DEBUG} -f
