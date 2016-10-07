#!/bin/bash

# $STI_SCRIPTS_PATH/assemble ran, package.json is now inside home
PACKAGE_JSON_PATH="$HOME/frontend/package.json"

if [ ! -e "$PACKAGE_JSON_PATH" ]; then
    echo "No frontend/package.json present, proceeding without frontend."
    exit
fi

cd $HOME

echo "Unstashing the packages..."
mv /tmp/stashed_node_modules $HOME/frontend/node_modules

echo "Building frontend..."
pushd frontend

# TODO remove this workaround for
#
#   ERROR in Missing binding /opt/app-root/src/frontend/node_modules/node-sass/vendor/linux-x64-46/binding.node
#   Node Sass could not find a binding for your current environment: Linux 64-bit with Node.js 4.x
#
# When running webpack
scl enable rh-nodejs4 'npm rebuild node-sass'

scl enable rh-nodejs4 'npm run build:prod:ci'
popd

mkdir -p public
mv frontend/dist/* public
