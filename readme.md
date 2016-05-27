## Logstash Docker based on passenger-base

Dockerfile to build a logstasg docker image based on Phusion's [pasenger-base](http://phusion.github.io/baseimage-docker/).

Includes a default logstash.conf that is meant to be overriden at runtime by mounting a volume with your own logstash.conf.


To build the image:

```
docker build -t logstash-baseimage .
```
 
 
 
 
 
Example use of this image in docker-compose.yml:

```
logstash:
  image: logstash-baseimage
  
  build:
    context: ./
 
  # listen on graylog port   
  ports:
    - "12201:12201/udp"
    
  volumes:
    - "./conf:/etc/logstash/conf.d"

  links:
    - elasticsearch
```
