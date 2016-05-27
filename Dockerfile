# Install logstash on passenger-base 
FROM phusion/baseimage

MAINTAINER  M.Holguin,  https://github.com/holgum

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Requires Java 8
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean
 
# install plugin dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzmq3 \
    && rm -rf /var/lib/apt/lists/*

# "ffi-rzmq-core" gem 
RUN mkdir -p /usr/local/lib \
  && ln -s /usr/lib/*/libzmq.so.3 /usr/local/lib/libzmq.so

# gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV LOGSTASH_MAJOR 2.2
ENV LOGSTASH_VERSION 1:2.2.4-1

RUN echo "deb http://packages.elastic.co/logstash/${LOGSTASH_MAJOR}/debian stable main" > /etc/apt/sources.list.d/logstash.list

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends logstash=$LOGSTASH_VERSION \
  && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/logstash/bin:$PATH

# Copy default logstash config
COPY conf/logstash.conf /etc/logstash/conf.d/logstash.conf

# config for startup of logstash service
RUN mkdir           /etc/service/logstash
ADD logstash-run.sh /etc/service/logstash/run

# run startup script to log boot time (not required - will write boot time to /tmp/boottime.txt)
# mainly leaving it here in order to show how to add things to 'my_init' to run at startup
RUN mkdir -p   /etc/my_init.d
ADD logtime.sh /etc/my_init.d/logtime.sh


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
