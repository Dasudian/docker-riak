# dasudian/riak

Basho riak database with search on docker images.

## Tags

- [`2.1.4`,`latest`(dockerfile)](https://github.com/Dasudian/docker-riak/blob/master/Dockerfile)  

## Expose ports

- 8098  (http)  
- 8087  (protobuf)  

## Volumes

- `/var/lib/riak`   (data)   

## Configuration

Default, the riak will use `bitcask` as the storeage backend, can use use other backend with docker environmnet `STORAGE_BACKEND` .  
For example:  

- STORAGE_BACKEND=bitcask/leveldb/memory  

Default the riak disable search function, can open it with docker environmnet `RIAK_SEARCH` .

- RIAK_SEARCH=off/on

And can use docker environmnet `ANTI_ENTROPY` to change `anti_entropy` configuration (default is active).  

- ANTI_ENTROPY=active/passive/active-debug

## Run

### Run a standalone riak

`docker run -p 8098:8098 -p 8087:8087 -d dasudian/riak`  

Open search:  

`docker run -p 8098:8098 -p 8087:8087 -e RIAK_SEARCH=on -d dasudian/riak`  

Mount the riak data to host disk:  

`docker run -v /data/riak:/var/lib/riak -d dasudian/riak`  

### Run a riak cluster

**NOTE:** To run a riak cluster, all riak container need to in the same network (bridge, overlay).  

1. Create a network (the example run the cluster on a single docker host).  

`docker network create -d bridge riak_bridge`

2. Run the riak nodes.  

`docker run -e NODE_HOST=riak1.db --net=riak_nw --net-alias=riak1.db -d dasudian/riak`  
`docker run -e NODE_HOST=riak2.db --net=riak_nw --net-alias=riak2.db -d dasudian/riak` 

**NOTE: the NODE_HOST should be same with network alias.**

3. Join the cluster.  

`docker exec -ti [container2] riak-admin cluster join riak@riak1.db`  
`docker exec -ti [container2] riak-admin cluster plan`  
`docker exec -ti [container2] riak-admin cluster commit`  

4. Check the cluster status.  

`docker exec -ti [container2] riak-admin cluster status`
