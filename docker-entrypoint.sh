#!/bin/bash
set -m

RIAK_CONFIG="/etc/riak/riak.conf"

if [[ -n ${NODE_HOST} ]]; then
  if [[ ${NODE_HOST} =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];then
    echo "Use the IP as the NODE_HOST, the nodename of riak is riak@$NODE_HOST"
  else
    C_IP=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
    grep -E "${NODE_HOST}" /etc/hosts
    if [[ $? -ne 0 ]];then
      echo "${C_IP} ${NODE_HOST}" >> /etc/hosts
    else
      sed -ri "s|.* ${NODE_HOST}|${C_IP} ${NODE_HOST}|" /etc/hosts
    fi
    echo "Use a HOST NAME as the NODE_HOST, the nodename of riak is riak@${NODE_HOST}"
  fi
  sed -ri "s|nodename = riak@127.0.0.1|nodename = riak@${NODE_HOST}|" ${RIAK_CONFIG}
fi

[[ -n ${STORAGE_BACKEND} ]] && sed -ri "s|storage_backend = bitcask|storage_backend = $STORAGE_BACKEND|" ${RIAK_CONFIG}
[[ -n ${RIAK_SEARCH} ]] && sed -ri "s|search = off|search = ${RIAK_SEARCH}|" ${RIAK_CONFIG}

# Set the permision for the riak data directory
chown riak:riak /var/lib/riak

if [[ "$1" = "supervisord" ]]; then
  echo "Run the riak container in the supervisord mode, with nodename 'riak@${NODE_HOST}'"
  supervisord -c /etc/supervisor/supervisord.conf
elif [[ "$1" = "console" ]]; then
  echo "Run the riak container in the erlang console mode, with node 'riak@${NODE_HOST}'"
  bash -c "/usr/sbin/riak console"
else
  exec $@
fi
