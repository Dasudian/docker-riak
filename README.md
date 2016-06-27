# dasudian/riak

Basho riak database with search on docker images.

## Tags

- [`2.1.4` (2.1.4/dockerfile)](https://github.com/Dasudian/docker-riak/blob/master/no-search/Dockerfile)  
- [`2.1.4-search` (2.1.4-search/dockerfile)](https://github.com/Dasudian/docker-riak/blob/master/search/Dockerfile)  
 
## Expose ports

- 8098  (http)  
- 8087  (protobuf)  

## Volumes

- `/var/lib/riak`   (data)  
- `/etc/riak`   (config)  

**NOTE:** if use `-e /srv/riak/data:/var/lib/riak`, make sure the directories */srv/riak/data* have full write permisions for all users.  

## Default Configuration

- STORAGE_BACKEND=leveldb - default use the `leveldb` as the storage backend.  
- NODE_HOST=127.0.0.1 - default use the `riak@127.0.0.1` as the nodename of riak (Standalone node mode).  

## Start

`docker run -p 8098:8098 -p 8087:8087 -v <host dir>:/var/lib/riak -d dasudian/riak:<tag>`  

### Run a riak cluster

**NOTE:** To run a riak cluster, all riak container need to in the same network (bridge, overlay).  

1. Create a network (the example run the cluster on a single docker host).  

`docker network create -d bridge riak_nw`

2. Run the riak nodes.  

`docker run --name riak1 -e NODE_HOST=riak1.db --net=riak_nw --net-alias=riak1.db -d dasudian/riak:<tag>`  
`docker run --name riak2 -e NODE_HOST=riak2.db --net=riak_nw --net-alias=riak2.db -d dasudian/riak:<tag>` 

3. Join the cluster.  

`docker exec -ti riak2 riak-admin cluster join riak@riak1.db`  
`docker exec -ti riak2 riak-admin cluster plan`  
`docker exec -ti riak2 riak-admin cluster commit`  

4. Check the cluster status.  

`docker exec -ti riak1 riak-admin cluster status`
