# PM2 Enterprise On-Premise

## Install

### 1/ Get the License Key

Ask us a license key [sales@keymetrics.io](sales@keymetrics.io)

### 2/ Install Docker and Docker Compose

```bash
sudo wget -qO- https://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 3/ Get the docker-compose.yml file & Start PM2.io EE

```bash
wget https://raw.githubusercontent.com/keymetrics/on-premise/master/docker-compose.yml
docker-compose up -d
```

### 4/ Connect to the Wizard

Go to http://server-ip-address/wizard

Required:

- Set the license key
- Set the address to access to the PM2.io interface
- Set the SMTP server to receive notifications

Optional:

- LDAP, Github login, Google login...

### 5/ Disable Wizard

```bash
docker-compose stop km-wizard
```

### 6/ Connect

Now open the url http://server-ip-address/, create an account and you are ready to go.

## FAQ

### How do I run the interface with SSL?

Instead of the [default docker-compose.yml file](https://raw.githubusercontent.com/keymetrics/on-premise/master/docker-compose.yml) use the [docker-compose.yml with ssl enabled](https://raw.githubusercontent.com/keymetrics/on-premise/master/docker-compose-ssl.yml)

Then SSL certificates which is running PM2 Enterprise on these path:
- Your private certificate on the path `/etc/ssl/pm2-ssl-certificate.crt`
- Your private key on the path `/etc/ssl/pm2-ssl-certificate.key`

If you want to use a custom proxy, you can find the nginx configuration that we use [here](https://github.com/keymetrics/on-premise/blob/master/km-nginx-dockerfile/nginx.conf) to configure the correct redirection for each service.

### How do I block new registration?

Start the wizard again:

```bash
docker-compose start km-wizard
```

Go to http://server-ip-address/wizard, edit the coniguration and restart all application with:

```bash
docker-compose restart
```

Do not forget to stop km-wizard once configuration is finished

### How do I update PM2.io EE?

Go back to the folder containing the docker-compose.yml you wget'ed and run:

```bash
docker-compose pull
docker-compose restart
```

### How do I run PM2 Agent behind a corporate proxy?

Just set the `PM2_PROXY` environment variable with the proxy address.

Example:

```bash
KEYMETRICS_NODE=<server-ip-address> PM2_PROXY=<proxy-address> pm2 link <secret> <public>
```

### What are the minium resources required to run PM2.io EE?

For 1 to 100 agents you will need at least a VM with 4 CPUs, 8gb RAM and 30GB SSD.

### Where is the data stored?

Data is stored within Elasticsearch. Make sure you do not wipe Elasticsearch data.

### Which ports must be opened for PM2 to communicate with PM2.io EE?

Port 443

### Other question

Tech: tech@keymetrics.io
Sales: sales@keymetrics.io
