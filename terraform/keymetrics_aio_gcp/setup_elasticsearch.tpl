#!/bin/bash

cd /tmp
curl -sSO "https://dl.google.com/cloudagents/install-logging-agent.sh"
chmod a+x install-logging-agent.sh
sudo /tmp/install-logging-agent.sh

# Install config for service if necessary

sudo service google-fluentd restart

sudo add-apt-repository ppa:webupd8team/java

sudo apt-get update

sudo apt-get install -y apt-transport-https

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

sudo apt-get update

sudo apt-get install -y elasticsearch openjdk-8-jre-headless


#########
# DISK
#########

if [ ! -f /.disk-config-done ]; then
    sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-data
    sudo mkdir /data
    echo UUID=`sudo blkid -s UUID -o value /dev/disk/by-id/google-data` /data ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab
    sudo mount /dev/disk/by-id/google-data
    sudo chown -R elasticsearch:elasticsearch /data
    sudo touch /.disk-config-done
fi


sudo systemctl enable elasticsearch.service

MACHINE_MEMORY_RAW=$(cat /proc/meminfo | grep MemTotal | awk 'match($0, /[a-zA-Z]*\:(.*)/) {print substr($2, RSTART, RLENGTH) }')
echo "Current machine memory:" $MACHINE_MEMORY_RAW "kB"
JAVA_MEMORY_TO_USER=$(awk "BEGIN {print $MACHINE_MEMORY_RAW / 2000}" | cut -d'.' -f 1)
echo "System memory to allocate for Java:" $JAVA_MEMORY_TO_USER "m"

cat <<EOF | sudo tee -a /etc/elasticsearch/elasticsearch.yml

cluster.name: ${cluster_name}
node.name: keymetrics-es

network.host: 0.0.0.0
http.port: 9200

path.data: /data

EOF

MEMORY_WITH_UNIT="$${JAVA_MEMORY_TO_USER}m"

echo "ES_JAVA_OPTS=\"-Xms$MEMORY_WITH_UNIT -Xmx$MEMORY_WITH_UNIT\"" | sudo tee -a /etc/default/elasticsearch

sudo service elasticsearch restart
