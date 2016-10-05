FROM centos/ruby-22-centos7

# ABOUT
# A Rails/webpack frontend image.
#
# If a frontend/package.json is found,
#
#   * node and npm will get installed
#   * the dependencies from said package.json are installed
#   * the frontend is built via `npm build TODO`
#   * the assets at frontend/dist are moved to public/
#
# This image is based on a S2I image but used in standard 'docker build'
# fashion. This is done by triggering $STI_SCRIPTS_PATH/assemble while
# building.

USER root

LABEL io.k8s.description="Platform for building and running Rails Application within Apache Passenger" \
      io.k8s.display-name="Apache 2.4 with Ruby 2.2" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby22,httpd"

# SLOW STUFF
# Slow operations, kept at top of the Dockerfile so they're cached for most changes.

# Install Apache httpd24.
RUN yum update -y && \
    INSTALL_PKGS="httpd httpd-devel apr-devel apr-util-devel sqlite3" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    yum clean all -y

# Install passenger.
RUN /bin/bash -c "gem install passenger --no-ri --no-rdoc && \
    export PATH=$PATH:/opt/rh/rh-ruby22/root/usr/local/bin && \
    passenger-install-apache2-module --auto --languages ruby && \
    passenger-config validate-install " # bogus comment to invalidate cache

# CONFIGURATION

### Apache
# Disable digest_module.
RUN sed -i "s/LoadModule auth_digest_module/#LoadModule auth_digest_module/" /etc/httpd/conf.modules.d/00-base.conf
ENV APACHE_RUN_USER 1001
ENV APACHE_PID_FILE /opt/app-root/httpd.pid
# TODO Why do we do this? I suspect it's because of the OpenShift PID hack for apache.
RUN mkdir -p /opt/app-root/httpd/pid

### Passenger
# Add a symlink to the installed passenger gem
# so we do not depend on the minor version installed.
RUN ln -s /opt/rh/rh-ruby22/root/usr/local/share/gems/gems/passenger-5.* /opt/passenger

### Rails
ENV RAILS_ENV=production \
  RAILS_ROOT=/opt/app-root/src

### Add configuration files.
ADD /contrib/bin $STI_SCRIPTS_PATH
ADD /contrib/etc/httpd /etc/httpd
ADD /contrib/usr/local/lib /usr/local/lib

# PERMISSIONS

# TODO Why do we do this? Check with the fix-permissions call in $STI_SCRIPTS_PATH/assemble.
RUN chgrp -R 0 ./ && \
    chmod -R g+rw ./ && \
    find ./ -type d -exec chmod g+x {} + && \
    chown -R 1001:0 ./

# TODO Why do we do this? Check with the fix-permissions call in $STI_SCRIPTS_PATH/assemble.
RUN chmod -R a+rwX /opt/app-root/httpd/pid && \
    chmod +x $STI_SCRIPTS_PATH/run-httpd.sh

# Workaround for base image: Do not install gems from development and test environments
# See https://github.com/sclorg/rhscl-dockerfiles/issues/26
ENV BUNDLE_WITHOUT=development:test

# DEPENDENCIES
# Add dependency declarations only, install dependencies.
# Doing this before adding the rest of the source ensures that as long
# as neither Gemfile nor Gemfile.lock change, Docker will keep the installed
# bundle in the cache.

ONBUILD USER root

# NPM: Add package.json, typings.json if present, install node if needed
ONBUILD ADD ./frontend/package.json ./frontend/typings.json /tmp/src/frontend/
ONBUILD RUN $STI_SCRIPTS_PATH/install-node.sh
ONBUILD RUN chown -R 1001 /tmp/src/
ONBUILD USER 1001
# NPM: Install packages
ONBUILD RUN $STI_SCRIPTS_PATH/install-npm-packages.sh

# Ruby: Add Gemfile, install the needed gems.
ONBUILD USER root
ONBUILD ADD ./Gemfile ./Gemfile.lock /tmp/src/
ONBUILD RUN chown -R 1001 /tmp/src/
ONBUILD USER 1001
ONBUILD RUN DISABLE_ASSET_COMPILATION=true $STI_SCRIPTS_PATH/assemble

# SOURCES
# Add the rest of the source.
ONBUILD USER root
ONBUILD ADD . /tmp/src/
ONBUILD RUN chown -R 1001 /tmp/src/
ONBUILD USER 1001
# Ruby: This time, `assemble` will take advantage of the cached gems,
# speeding up most builds.
ONBUILD RUN $STI_SCRIPTS_PATH/assemble
# NPM: Build frontend.
ONBUILD RUN $STI_SCRIPTS_PATH/build-frontend.sh

USER 1001

# ENTRYPOINT

CMD $STI_SCRIPTS_PATH/run-httpd.sh
