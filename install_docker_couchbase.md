


# Install Couchbase via Docker Image

#### Reference docs:
https://hub.docker.com/r/couchbase/server/
https://docs.couchbase.com/server/6.0/install/getting-started-docker.html
https://blog.couchbase.com/couchbase-docker-container/
https://docs.couchbase.com/server/4.1/install/deployment-docker.html


#### Clustering:
https://github.com/couchbase/docker/blob/master/compose/couchbase-server-sync-gateway/docker-compose.yml
https://github.com/wheniwork/couchbase-provisioner/blob/master/docker-compose.yml


#### Logging:
http://docs.couchdb.org/en/stable/config/logging.html


#### Installation:
docker run -d --name db -p 8091-8096:8091-8096 -p 11210-11211:11210-11211 couchbase


```ruby
version: '3'
services:
    db:
        image: couchbase
        container_name: cbase
        tty: true
        stdin_open: true
        restart: always
		image: couchbase/server
		ports:
			- 8091:8091
			- 8092:8092 
			- 8093:8093 
			- 11210:11210
        volumes:
            - /opt/couchbase/data:/opt/couchdb/data
            - /opt/couchbase/etc:/opt/couchdb/etc
```

and to use a volume instead of a directory

```ruby
...
	volumes:
		- cb-data:/opt/couchdb/data
		- cb-etc:/opt/couchdb/etc

volumes:
  cb-data:
  cb-etc:
```


adding a network

```ruby

...
		networks:
			cb_net:
				ipv4_address: 192.168.50.10
				aliases:
					- archangeldb




networks:
    cb_net:
        driver: bridge
        ipam:
            driver: default
            config: [{subnet: 192.168.50.0/24}]
```


CouchDB uses /opt/couchdb/data to store its data, and is exposed as a volume.

CouchDB uses /opt/couchdb/etc to store its configuration.

 mysql:
    image: mysql
    volumes:
       - db-data:/var/lib/mysql/data
