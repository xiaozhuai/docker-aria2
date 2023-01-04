#!/bin/sh
set -e

echo "UID: $(id -u)"
echo "GID: $(id -g)"

touch /config/aria2.session
if [ ! -e /config/aria2.conf ]; then
  cp /aria2.conf.default /config/aria2.conf
fi

aria2c --conf-path=/config/aria2.conf
