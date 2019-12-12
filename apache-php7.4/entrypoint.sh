#!/bin/bash

USER_ID=${USER_ID:-33}
GROUP_ID=${GROUP_ID:-33}
CURRENT_USER_ID=`id -u www-data`
CURRENT_GROUP_ID=`id -g www-data`

if [ $USER_ID -ne $CURRENT_USER_ID ]; then
  echo "Updating www-data UID to $USER_ID"
  usermod -u $USER_ID www-data
  find / -user $CURRENT_USER_ID -exec chown -h www-data {} \; >&2
fi

if [ $GROUP_ID -ne $CURRENT_GROUP_ID ]; then
  echo "Updating www-data GID to $GROUP_ID"
  groupmod -g $GROUP_ID www-data
  find / -group $CURRENT_GROUP_ID -exec chgrp -h www-data {} \; >&2
fi

mkdir -p /var/www/html/public
chown $USER_ID.$GROUP_ID /var/www/html/public
chown $USER_ID.$GROUP_ID /var/www

set -e
# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

exec "$@"
