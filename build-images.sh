#!/bin/bash

version="$1"

if [ -z "${version}" ]; then
	echo "No version set, is this really what you want?"
	sleep 5
fi

for c in bacula-db bacula-db-data bacula-sd bacula-dir; do
	imgname=`echo ${c} | sed 's,^bacula,bacula-opensource,'`
	docker build --no-cache -t redcoolbeans/${imgname}:latest ${c}
	if [ ! -z "${version}" ]; then
		docker build --no-cache -t redcoolbeans/${imgname}:${version} ${c}
	fi
done

