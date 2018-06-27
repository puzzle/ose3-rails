#!/bin/bash

set -e pipefail

rm -rf $APACHE_PID_FILE

# Set up logging workarounds for those apps that do not
# log to standard out.

log_path=/opt/app-root/src/log/${RAILS_ENV:-production}.log

if [ "$LEAVE_RAILS_LOG_FILE_IN_PLACE" == "1" ]; then
    mkdir -p /opt/app-root/src/log
    touch $log_path

    tail -f $log_path
else
    if [ "$RAILS_LOGS_TO_STDOUT" != "1" ]; then
        rm -rf /tmp/log_pipe_rails
        mkfifo -m 777 /tmp/log_pipe_rails

        rm -rf $log_path
        mkdir -p /opt/app-root/src/log
        ln -s /tmp/log_pipe_rails $log_path

        # Loop forces reopening of file after EOFs
        ( while true; do
              cat < /tmp/log_pipe_rails
              sleep 1
          done ) &
    fi
fi

# Use libmapuid to map random UIDs generated by OpenShift
# to correct passwd entry.
# Otherwise the following error occurs:
#
#   Cannot checkout session due to Passenger::RuntimeException:
#   Cannot get user database entry for user UID 1000190000;
#     it looks like your system's user database is broken, please fix it.

export LD_PRELOAD=/usr/local/lib/libmapuid.so

# Activate the correct configuration for HTTP(S)

if [[ $USE_SSL == "1" ]]; then
    echo '{ "component": "apache", "severity": "info", "message": "Listening for HTTPS traffic on port 8443" }'
    mv /etc/httpd/features/https.conf /etc/httpd/conf.d/1_https.conf
else
    echo '{ "component": "apache", "severity": "info", "message": "Listening for HTTP traffic on port 8080" }'
    mv /etc/httpd/features/http.conf /etc/httpd/conf.d/1_http.conf
fi

# Start Apache and have it's output converted to JSON.

jsonize="$(dirname $0)/jsonize"

if [[ "$RAW_APACHE_LOGS" == "1" ]]; then
    exec \
        # Disable buffering so we see logs instantly
        stdbuf -oL -eL \
        /usr/sbin/apachectl -DFOREGROUND
else
    exec \
        # Disable buffering so we see logs instantly
        stdbuf -oL -eL \
        /usr/sbin/apachectl -DFOREGROUND \
        1> >($jsonize "info") \
        2> >($jsonize "error")
fi