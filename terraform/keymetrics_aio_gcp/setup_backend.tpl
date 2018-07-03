#!/bin/bash

cat <<EOF | sudo tee -a /etc/environment
KM_ELASTICSEARCH_HOST="http://${es_private_ip}:9200/"
KM_MONGO_URL="mongodb://${mongodb_private_ip}/keymetrics"
KM_REDIS_URL="redis://${redis_private_ip}/"
EOF

export KM_ELASTICSEARCH_HOST="http://${es_private_ip}:9200/"
export KM_MONGO_URL="mongodb://${mongodb_private_ip}/keymetrics"
export KM_REDIS_URL="redis://${redis_private_ip}/"

sudo sed -i "s/NODE_ENV='production'/NODE_ENV='dedicated'/g" /home/ubuntu/.bashrc 

export PM2_HOME=/home/ubuntu/.pm2

pm2 restart all --update-env 
pm2 flush 
pm2 reset all 
pm2 save 

# Google Fluentd Configuration

for i in ${log_files}; do
    cat <<EOF | sudo tee -a /etc/google-fluentd/config.d/pm2.conf
<source>
  @type tail
  format none
  path /home/ubuntu/.pm2/logs/$i
  pos_file /var/lib/google-fluentd/pos/$i.pos
  read_from_head true
  tag keymetrics-$i
</source>
EOF

done

sudo service google-fluentd restart
