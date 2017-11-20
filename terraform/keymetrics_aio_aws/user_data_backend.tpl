#!/bin/bash

set -e
set -o pipefail

cat <<EOF >> /etc/environment
KM_ELASTICSEARCH_HOST="http://${es_private_id}:9200/"
KM_MONGO_URL="mongodb://${mongodb_private_id}/keymetrics"
KM_REDIS_URL="redis://${redis_private_ip}/"
KM_DEDICATED_KEY="${keymetrics_key}"
KM_SITE_URL="http://${backend_public_ip}"
SMTP_USER="${smtp_username}"
SMTP_PASSWORD="${smtp_password}"
SMTP_HOST="${smtp_host}"
SMTP_SENDER="${smtp_sender}"

EOF

export KM_ELASTICSEARCH_HOST="http://${es_private_id}:9200/"
export KM_MONGO_URL="mongodb://${mongodb_private_id}/keymetrics"
export KM_REDIS_URL="redis://${redis_private_ip}/"
export KM_DEDICATED_KEY="${keymetrics_key}"
export KM_SITE_URL="http://${backend_public_ip}"
export SMTP_USER="${smtp_username}"
export SMTP_PASSWORD="${smtp_password}"
export SMTP_HOST="${smtp_host}"
export SMTP_SENDER="${smtp_sender}"

sed -i "s/NODE_ENV='production'/NODE_ENV='dedicated'/g" /home/ubuntu/.bashrc

chown -R ubuntu:ubuntu /home/ubuntu

export PM2_HOME=/home/ubuntu/.pm2

pm2 restart all --update-env
pm2 flush
pm2 reset all
pm2 save

curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O

mkdir /etc/awslogs
cat <<EOF > /etc/awslogs/awscli.conf
[default]
region = ${region}
[plugins]
cwlogs = cwlogs
EOF

cat <<EOF > /tmp/awslogs.conf
[general]
state_file = /var/awslogs/state/agent-state

EOF

for i in ${log_files}; do

    cat <<EOF >> /tmp/awslogs.conf

[$i]
datetime_format = %Y-%m-%d %H:%M
file = /home/ubuntu/.pm2/logs/$i
buffer_duration = 5000
log_stream_name = $i
initial_position = start_of_file
log_group_name = /keymetrics/${environment}

EOF
    
done

python ./awslogs-agent-setup.py -n --region ${region} -c /tmp/awslogs.conf

service awslogs restart
