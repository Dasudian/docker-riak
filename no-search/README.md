# dasudian/riak:2.1.3

Basho riak database docker images, version **2.1.3** .  

## Tags

- [`latest` (latest/dockerfile)](https://github.com/Dasudian/docker-riak/blob/master/no-search/Dockerfile)  
- [`search` (search/dockerfile)](https://github.com/Dasudian/docker-riak/blob/master/search/Dockerfile) 

## Expose ports

- 8098  (http)  
- 8087  (protobuf)  

## Volumes

- `/var/lib/riak`   (data)  
- `/etc/riak`   (config)  

**NOTE:** if use `-e /srv/riak/data:/var/lib/riak`, make sure the directories */srv/riak/data* have full write permisions for all users.  

## Start

`docker run -p 8098:8098 -p 8087:8087 -v <host dir>:/var/lib/riak -d dasudian/riak`  
