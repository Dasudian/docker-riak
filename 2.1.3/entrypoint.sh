#!/bin/bash
set -m

RIAK_CONFIG="/etc/riak/riak.conf"

SEDARG="-i 's/%STORAGE_BACKEND%/${STORAGE_BACKEND}/' ${RIAK_CONFIG}"
eval sed ${SEDARG}

NODE_IP=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
SEDARG="-i 's/%NODE_IP%/${NODE_IP}/' ${RIAK_CONFIG}"
eval sed ${SEDARG}

supervisord -n &

echo "Start the container."

if [ ! -z ${CLUSTER_NODE} ]; then
    while :
    do
        sleep 5
        RT=$(su - riak -c "/usr/sbin/riak ping")
        if [ ${RT} = "pong" ]; then
            su - riak -c "/usr/sbin/riak-admin cluster join ${CLUSTER_NODE}"
            if [ $? -eq 0 ]; then
                if [ "$LAST_NODE" = "yes" ]; then
                    sleep 5
                    su - riak -c "/usr/sbin/riak-admin cluster plan"
                    su - riak -c "/usr/sbin/riak-admin cluster commit"
                fi
                break
            else
                echo "Join cluster to ${CLUSTER_NODE} failed."
                break
            fi
        fi
    done
fi

fg %1
