#!/bin/bash

cd /tmp
curl -sSO "https://dl.google.com/cloudagents/install-logging-agent.sh"
chmod a+x install-logging-agent.sh
sudo /tmp/install-logging-agent.sh

# Install config for service if necessary

sudo service google-fluentd restart

apt-get install -y redis-server
sed -i "s/bind .*/bind 0\.0\.0\.0/g" /etc/redis/redis.conf
service redis restart
