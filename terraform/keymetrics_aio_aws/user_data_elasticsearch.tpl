#!/bin/bash

add-apt-repository ppa:webupd8team/java

apt-get update

apt-get install -y apt-transport-https

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list

apt-get update

apt-get install -y elasticsearch

echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections

apt-get install -y oracle-java8-installer

systemctl enable elasticsearch.service

MACHINE_MEMORY_RAW=$(cat /proc/meminfo | grep MemTotal | awk 'match($0, /[a-zA-Z]*\:(.*)/) {print substr($2, RSTART, RLENGTH) }')
echo "Current machine memory:" $MACHINE_MEMORY_RAW "kB"
JAVA_MEMORY_TO_USER=$(awk "BEGIN {print $MACHINE_MEMORY_RAW / 2000}" | cut -d'.' -f 1)
echo "System memory to allocate for Java:" $JAVA_MEMORY_TO_USER "m"

cat <<EOF >> /etc/elasticsearch/elasticsearch.yml

cluster.name: ${cluster_name}
node.name: keymetrics-es

network.host: 0.0.0.0
http.port: 9200

EOF

MEMORY_WITH_UNIT="$${JAVA_MEMORY_TO_USER}m"

echo "ES_JAVA_OPTS=\"-Xms$MEMORY_WITH_UNIT -Xmx$MEMORY_WITH_UNIT\"" >> /etc/default/elasticsearch

service elasticsearch restart
