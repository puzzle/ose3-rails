#!/bin/bash

function scheduled_indexing {
  while :
  do
    /usr/bin/indexer --config config/production.sphinx.conf --all --rotate
    sleep 10
  done
}

# create sphinx daemon config
bundle exec rake ts:configure

# create initial index
bundle exec rake ts:index


# start indexer and sphinx daemon
scheduled_indexing & \
/usr/bin/searchd --config ./config/production.sphinx.conf --nodetach
