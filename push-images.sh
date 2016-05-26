#!/bin/bash

version="$1"

if [ -z "${version}" ]; then
	echo "No version set, is this really what you want?"
	sleep 5
fi

for c in bacula-db bacula-db-data bacula-sd bacula-dir; do
	imgname=`echo ${c} | sed 's,^bacula,bacula-opensource,'`
	docker push redcoolbeans/${imgname}:latest
	if [ ! -z "${version}" ]; then
		docker push redcoolbeans/${imgname}:${version}
	fi
done
