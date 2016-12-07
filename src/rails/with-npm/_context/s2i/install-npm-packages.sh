#!/bin/bash

cd /opt/app-root/src

pushd frontend

# Restore build artifacts
if [ "$(ls /tmp/artifacts/node_modules 2>/dev/null)" ]; then
    echo "NOT Restoring node modules from artifacts..."
    # This breaks npm build:prod:ci, we should check why.
    # If the instructions below are enabled, webpack fails:
    #
    # OUTPUT
    # > socialweb@0.0.1 build:prod:ci /opt/app-root/src/frontend
    # > webpack --config config/webpack.prod.js --progress --profile --bail
    # ( no output)
    # error: build error: non-zero (13) exit code from 172.30.16.126:5000/pitc-rails-bi-dev/ose3-rails-with-npm
    # OUTPUT END

    #mv /tmp/artifacts/node_modules .

    #rm -rf ${HOME}/.npm
    #mv /tmp/artifacts/npm_cache ${HOME}/.npm
fi

ls /opt/app-root/src/frontend

scl enable rh-nodejs4 'npm install'
scl enable rh-nodejs4 'npm prune'

# Remember build artifacts
echo "NOT Linking node modules and cache to artifacts_out..."
#ln -s /opt/app-root/src/frontend/node_modules /tmp/artifacts_out/node_modules
#ln -s ${HOME}/.npm /tmp/artifacts_out/npm_cache

popd
