#!/bin/bash

if [ -z $SPHINX_INTERVAL_TIME ]
then
  $SPHINX_INTERVAL_TIME=3600 # 10mins
fi

function scheduled_indexing {
  while :
  do
    echo 'Starting indexer ...'
    /usr/bin/indexer --config config/production.sphinx.conf --all --rotate
    echo '... indexing done'
    sleep $SPHINX_INTERVAL_TIME
  done
}

# create sphinx daemon config
bundle exec rake ts:configure

# create initial index
bundle exec rake ts:index

# start indexer and sphinx daemon
scheduled_indexing & \
/usr/bin/searchd --config ./config/production.sphinx.conf --nodetach
