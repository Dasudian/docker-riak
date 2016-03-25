# dasudian/riak:2.1.3

Basho riak database docker images, version **2.1.3** .  

## Expose ports

- 8098  (http)  
- 8087  (protobuf)  

## Volumes

- `/var/lib/riak`   (date)  
- `/var/log/riak`   (logs)  

## Start

`docker run -p 8098:8098 -p 8087:8087 -v <host dir>:/var/lib/riak -v <host dir>:/var/log/riak -d dasudian/riak:2.1.3`  
