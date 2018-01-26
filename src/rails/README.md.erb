# ose3-rails

Dockerfiles for Ruby on Rails applications with Apache2 and mod_passenger. Intended for usage on OpenShift 3.
*nodejs* additionally contains the necessary tools to build an npm frontend and serve it from `public/`.
*sphinx* additionally contains a sphinx installation and a script to run the sphinx daemon.

Those images are is based on centos/ruby-22-centos7: https://github.com/sclorg/s2i-ruby-container/tree/master/2.2

## Configuration

The following environment variables can be used to configure the container.

### LEAVE_RAILS_LOG_FILE_IN_PLACE

If set to "1", this will leave rails' production log file in place. Everything that's written to the file will still be mirrored to stdout.
This is useful if you archive log files instead of container stdout.

### PASSENGER_MIN_INSTANCES

Value of (PassengerMinInstances)[https://www.phusionpassenger.com/library/config/apache/reference/#passengermininstances]. Defaults to 2.

### PASSENGER_MAX_POOL_SIZE

Value of (PassengerMaxPoolSize)[https://www.phusionpassenger.com/library/config/apache/reference/#passengermaxpoolsize]. Defaults to 6.

### LEAVE_RAILS_LOG_FILE_IN_PLACE

If set to "1", this will leave rails' production log file in place. Everything that's written to the file will still be mirrored to stdout.
This is useful if you archive log files instead of container stdout.


## Apache configuration

You can further configure apache for your needs by providing the file `.s2i/httpd-extra.conf` in your source.

An example `httpd-extra.conf` which enables serving files via X-SendFile headers:

```
XSendFile On
# Whitelist a single directory whose contents will be served by apache
# if the app sends a corresponding X-SendFile header
XSendFilePath /opt/app-root/src/store
```
