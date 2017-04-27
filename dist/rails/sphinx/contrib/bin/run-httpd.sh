#!/bin/bash

rm -rf $APACHE_PID_FILE

# Set up log pipes in order to join all logs' outputs to stdout
mkfifo -m 777 /tmp/log_pipe_apache
mkfifo -m 777 /tmp/log_pipe_rails

cat < /tmp/log_pipe_apache 2>&1 | sed 's/^/apache: /' &

log_path=/opt/app-root/src/log/${RAILS_ENV:-production}.log
rm -rf $log_path
mkdir -p /opt/app-root/src/log
ln -s /tmp/log_pipe_rails $log_path
# Loop forces reopening of file after EOFs
( while true; do
      cat < /tmp/log_pipe_rails | sed 's/^/rails: /'
      sleep 1
  done ) &

# Use libmapuid to map ose generate uid for passenger to correct passwd entry
# otherwise the following error occurs:
# Cannot checkout session due to Passenger::RuntimeException:
# Cannot get user database entry for user UID 1000190000; it looks like your system's user database is broken, please fix it.
export LD_PRELOAD=/usr/local/lib/libmapuid.so

exec /usr/sbin/apachectl -DFOREGROUND 2>&1 | sed 's#^#apache stdout/stderr:#'
