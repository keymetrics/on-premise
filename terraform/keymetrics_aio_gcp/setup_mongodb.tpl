#!/bin/bash

cd /tmp
curl -sSO "https://dl.google.com/cloudagents/install-logging-agent.sh"
chmod a+x install-logging-agent.sh
sudo /tmp/install-logging-agent.sh

# Install config for service if necessary

sudo service google-fluentd restart

echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee -a /etc/apt/sources.list.d/mongodb-org-3.4.list

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

sudo apt-get update
sudo apt-get install -y mongodb-org

#########
# DISK
#########

if [ ! -f /.disk-config-done ]; then
    sudo service mongodb stop
    sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-data
    echo UUID=`sudo blkid -s UUID -o value /dev/disk/by-id/google-data` /var/lib/mongodb ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab
    sudo mkdir -p /var/lib/mongodb
    sudo mount /dev/disk/by-id/google-data
    sudo chown -R mongodb:mongodb /var/lib/mongodb
    sudo touch /.disk-config-done
fi

sudo sed -i "s/127\.0\.0\.1/0\.0\.0\.0/g" /etc/mongod.conf

sudo service mongod restart
