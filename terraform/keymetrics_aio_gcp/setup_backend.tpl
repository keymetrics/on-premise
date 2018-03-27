#!/bin/bash

cat <<EOF | sudo tee -a /etc/environment
KM_ELASTICSEARCH_HOST="http://${es_private_ip}:9200/"
KM_MONGO_URL="mongodb://${mongodb_private_ip}/keymetrics"
KM_REDIS_URL="redis://${redis_private_ip}/"
KM_DEDICATED_KEY="${keymetrics_key}"
KM_SITE_URL="http://${backend_public_ip}"
KM_SMTP_USER="${smtp_username}"
KM_SMTP_PASSWORD="${smtp_password}"
KM_SMTP_HOST="${smtp_host}"
KM_SMTP_SENDER="${smtp_sender}"
EOF

export KM_ELASTICSEARCH_HOST="http://${es_private_ip}:9200/"
export KM_MONGO_URL="mongodb://${mongodb_private_ip}/keymetrics"
export KM_REDIS_URL="redis://${redis_private_ip}/"
export KM_DEDICATED_KEY="${keymetrics_key}"
export KM_SITE_URL="${backend_public_ip}"
export KM_SMTP_USER="${smtp_username}"
export KM_SMTP_PASSWORD="${smtp_password}"
export KM_SMTP_HOST="${smtp_host}"
export KM_SMTP_SENDER="${smtp_sender}"

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
