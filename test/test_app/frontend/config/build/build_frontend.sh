#!/bin/bash

set -e

cd $(dirname $0)

node --version

# Create fake build output for assemble script
mkdir ../../dist
touch ../../dist/app.js
