#!/bin/bash

: ${BACULA_DEBUG:="50"}

# Volume path for disk-based backups.
chown bacula /b

echo "==> Looking for new plugins"
_plugins=`ls -1 /plugins`
echo ${_plugins} | grep -q -E '(\.rpm$)'
if [[ "$?" -eq 0 ]]; then
  for p in ${_plugins}; do
    yum -q localinstall -y /plugins/$p
  done
fi

echo "==> Starting Bacula SD"
sudo -u bacula /opt/bacula/bin/bacula-sd -c /opt/bacula/etc/bacula-sd.conf -d ${BACULA_DEBUG} -f
