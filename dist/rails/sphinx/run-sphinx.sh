#!/bin/bash

function scheduled_indexing {
  while :
  do
    /usr/bin/indexer --config config/production.sphinx.conf --all --rotate
    sleep 10
  done
}

scheduled_indexing & \
/usr/bin/searchd --config ./config/production.sphinx.conf --nodetach &
