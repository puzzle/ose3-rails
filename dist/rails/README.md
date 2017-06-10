# ose3-rails

Dockerfiles for Ruby on Rails applications with Apache2 and mod_passenger. Intended for usage on OpenShift 3.
*nodejs* additionally contains the necessary tools to build an npm frontend and serve it from `public/`.
*sphinx* additionally contains a sphinx installation and a script to run the sphinx daemon.

Those images are is based on centos/ruby-22-centos7: https://github.com/sclorg/s2i-ruby-container/tree/master/2.2

## Configuration

The following environment variables can be used to configure the container.

### LEAVE_RAILS_LOG_FILE_IN_PLACE

If set to "1", this will leave rails' production log file in place. Everything that's written to the file will still be mirroed to stdout.
This is useful if you archive log files instead of container stdout.

