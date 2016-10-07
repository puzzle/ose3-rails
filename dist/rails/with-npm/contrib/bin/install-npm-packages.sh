#!/bin/bash

# $STI_SCRIPTS_PATH/assemble didn't run yet, package.json is still at /tmp/src
PACKAGE_JSON_PATH="/tmp/src/frontend/package.json"

if [ ! -e "$PACKAGE_JSON_PATH" ]; then
    echo "No frontend/package.json present, proceeding without frontend."
    exit
fi

echo "Installing packages..."

cd /tmp/src/frontend
scl enable rh-nodejs4 'npm install'

# Assemble will fail if its' executed the second time and theres' already
# a folder at the target directory.
echo "Stashing the packages to not confuse assemble script..."
mv /tmp/src/frontend/node_modules /tmp/stashed_node_modules
rm -rf /tmp/src/frontend
