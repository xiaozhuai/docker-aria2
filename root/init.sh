#!/bin/sh
set -e

UID=`id -u`
GID=`id -g`

echo "UID: $UID"
echo "UID: $GID"

chmod 755 /config
chmod 755 /downloads

touch /config/aria2.session
if [[ ! -e /config/aria2.conf ]]
then
  cp /aria2.conf.default /config/aria2.conf
fi

aria2c --conf-path=/config/aria2.conf > /dev/stdout 2 > /dev/stderr
