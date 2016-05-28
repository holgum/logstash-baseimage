## Logstash Docker based on passenger-base

Dockerfile to build a logstash docker image based on Phusion's [baseimage-docker](http://phusion.github.io/baseimage-docker/).

Includes a default logstash.conf that is meant to be overridden at runtime by mounting a volume with your own logstash.conf.
Currently based on logstash 2.2.


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
