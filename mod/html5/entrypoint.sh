#!/bin/sh
set -e

cd /app
export ROOT_URL=http://127.0.0.1/html5client
export MONGO_URL=mongodb://10.7.7.6/meteor
export NODE_ENV=production
export ENVIRONMENT_TYPE=production
export SERVER_WEBSOCKET_COMPRESSION=0
export PORT=3000
export LANG=en_US.UTF-8

if [ "$DEV_MODE" == true ]; then
    echo "DEV_MODE=true, disable TLS certificate rejecting"
    export NODE_TLS_REJECT_UNAUTHORIZED=0
fi

# copy static files into volume for direct access by nginx
# https://github.com/bigbluebutton/bigbluebutton/issues/10739
if [ -d "/html5-static" ]; then
    rm -rf /html5-static/*
    cp -r /app/programs/web.browser/* /html5-static
fi

rm -f /app/programs/server/assets/app/config/settings.yml
dockerize \
    -template /app/programs/server/assets/app/config/settings.yml.tmpl:/app/programs/server/assets/app/config/settings.yml \
    su-exec meteor node main.js
