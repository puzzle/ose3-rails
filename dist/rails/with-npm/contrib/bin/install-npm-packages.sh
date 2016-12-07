#!/bin/bash

cd /opt/app-root/src

pushd frontend

scl enable rh-nodejs4 'npm install'

popd frontend
