#!/bin/bash

# $STI_SCRIPTS_PATH/assemble didn't run yet, package.json is still at /tmp/src
PACKAGE_JSON_PATH="/tmp/src/frontend/package.json"

if [ ! -e "$PACKAGE_JSON_PATH" ]; then
    echo "No frontend/package.json present, proceeding without frontend."
    exit
fi

echo "Installing node..."

yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y
