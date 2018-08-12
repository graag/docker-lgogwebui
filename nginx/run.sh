#!/bin/bash -e

# Initialize first run, do no execute of the DB exists
if [[ ! -e /.firstrun_done ]]; then
    apt-get update
    apt-get install openssl
    rm -rf /var/lib/apt/lists/*
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 -subj "/C=PL/ST=lgogwebui/L=lgogwebui/O=lgogwebui/OU=lgogwebui/CN=$NGINX_HOST" -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt
    envsubst '$NGINX_HOST $NGINX_PORT' < /etc/nginx/conf.d/lgogwebui.template > /etc/nginx/conf.d/lgogwebui.conf
    cat /etc/nginx/conf.d/lgogwebui.conf
    touch /.firstrun_done
fi

exec nginx -g 'daemon off; error_log /dev/stderr error;'
