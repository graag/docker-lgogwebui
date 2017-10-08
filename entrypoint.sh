#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-1000}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
chown user /home/user
export HOME=/home/user

if [ -z "$@" ]
then
    exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
else
    exec gosu user "$@"
fi
