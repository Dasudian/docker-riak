#!/bin/bash
set -m

RIAK_CONFIG="/etc/riak/riak.conf"

C_IP=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

if [[ $NODE_HOST =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
  echo "Use the IP as the NODE_HOST, the nodename of riak is riak@$NODE_HOST"
else
  grep -E "^$C_IP $NODE_HOST$" /etc/hosts
  if [ $? -ne 0 ];then
    echo "$C_IP $NODE_HOST" >> /etc/hosts
    echo "Use a HOST NAME as the NODE_HOST, the nodename of riak is riak@$NODE_HOST"
  fi
fi

sed -ri "s|nodename = .*|nodename = riak@$NODE_HOST|" $RIAK_CONFIG
sed -ri "s|storage_backend = .*|storage_backend = $STORAGE_BACKEND|" $RIAK_CONFIG

if [ "$1" = "supervisord" ]; then
  supervisord -n &
  fg %1
else
  exec $@
fi
