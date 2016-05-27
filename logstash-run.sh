#!/bin/sh

# if needed, use setuser, otherwise command will run as root:

# exec /sbin/setuser logstash /opt/logstash/bin/logstash agent -f /etc/logstash/conf.d/logstash.conf --log /var/log/logstash.log 2>&1  >> /var/log/logstash-run.log

exec /opt/logstash/bin/logstash agent -f /etc/logstash/conf.d/logstash.conf --log /var/log/logstash.log 2>&1  >> /var/log/logstash-run.log

