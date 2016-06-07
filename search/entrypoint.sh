#!/bin/bash
set -m

RIAK_CONFIG="/etc/riak/riak.conf"

C_IP=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
# NODE_IP="127.0.0.1"
grep "nodename = riak@$C_IP" ${RIAK_CONFIG}
if [ $? -ne 0 ];then
    echo "Set riak nodename to riak@$C_IP"
    sed -ri "s|nodename = .*|nodename = riak@$C_IP|" $RIAK_CONFIG
fi

sed -ri "s|storage_backend = .*|storage_backend = $STORAGE_BACKEND|" $RIAK_CONFIG

if [ "$1" = "supervisord" ]; then
  supervisord -n &
  echo "Start the riak container with nodename riak@$C_IP."
  fg %1
else
  exec $@
fi
