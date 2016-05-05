#!/bin/bash
set -m

RIAK_CONFIG="/etc/riak/riak.conf"
# RIAK_CONFIG="riak.conf"
# STORAGE_BACKEND="leveldb"

storage_backend=$(egrep "^storage_backend = .*" ${RIAK_CONFIG} | awk -F' = ' '{print $2}')
if [ "${storage_backend}" != "${STORAGE_BACKEND}" ];then
    echo "Set riak storage backend to ${STORAGE_BACKEND}"
    SEDARG="-i 's/^storage_backend = .*/storage_backend = ${STORAGE_BACKEND}/' ${RIAK_CONFIG}"
    eval sed ${SEDARG}
fi

NODE_IP=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
# NODE_IP="127.0.0.1"
grep "nodename = riak@${NODE_IP}" ${RIAK_CONFIG}
if [ $? -ne 0 ];then
    echo "Set riak nodename to riak@${NODE_IP}"
    SEDARG="-i 's/^nodename = riak@.*/nodename = riak@${NODE_IP}/' ${RIAK_CONFIG}"
    eval sed ${SEDARG}
fi

supervisord -n &

echo "Start the container."

if [ ! -z ${CLUSTER_NODE} ]; then
    while :
    do
        sleep 5
        RT=$(riak ping)
        if [ "${RT}" = "pong" ]; then
            riak-admin cluster status | grep ${CLUSTER_NODE}
            if [ $? -eq 0 ]; then
                echo "Already in the cluster."
                break
            else
                echo "Waiting 20s to join the cluster."
                sleep 20
                riak-admin cluster join ${CLUSTER_NODE}
                if [ $? -eq 0 ]; then
                    if [ "$LAST_NODE" = "yes" ]; then
                        sleep 2
                        echo "Commit the plan."
                        riak-admin cluster plan
                        riak-admin cluster commit
                    fi
                    break
                else
                    echo "Join cluster to ${CLUSTER_NODE} failed."
                    break
                fi
            fi
        fi
    done
fi

fg %1
