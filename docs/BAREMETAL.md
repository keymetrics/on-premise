# PM2 EE Baremetal deployment

## Requirements

### Minimum recommended versions

- Docker: 17.12.0 (package: 1.5)
- Docker-compose: 1.8.0 (package: 1.8.0)

### Install Docker & Docker compose

```bash
sudo wget -qO- https://get.docker.com/ | sh
sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Then make sure you have logged-in on the official docker hub to be able to pull the private images:

```bash
docker login
```

Note that the technical team should have asked you to create a dummy account to be able to access all of your images.

## Steps to Install

You have two way docker-compose file available, one with over HTTP and another one with HTTPS.

If you already a piece of software that handle the HTTPS for you or that you prefer using HTTP, you can get this dockerfile :
```bash
wget https://raw.githubusercontent.com/keymetrics/on-premise/master/docker/docker-compose.yml
```

Otherwise, download the docker compose with the SSL configured into our nginx instance:
```bash
wget https://raw.githubusercontent.com/keymetrics/on-premise/master/docker/docker-compose.ssl.yml && mv docker-compose.ssl.yml docker-compose.yml
```

Then you will need to place your private certificate on the path `/etc/ssl/pm2-ssl-certificate.crt` and the private key on the path `/etc/ssl/pm2-ssl-certificate.key`, both on the host where you are launching the docker-compose file.

If you want to use a custom proxy, you can find the nginx configuration that we use [here](https://github.com/keymetrics/on-premise/blob/master/docker/dockerfiles/nginx.conf) to configure the correct redirection for each service.

###

### Start all the services

```bash
docker-compose up -d
```

Check the logs via:

```bash
docker-compose logs
```

| In the beginning some connections errors might appears but it's not critical (elasticsearch take few seconds to boot so the backend will restart for few seconds then connect when his ready)

### Configure the instance

#### Minimal configuration

**NOTE**: When we refer as `instance_address`, we mean the final address where you want to installation to be available (if you plan to use a specific domain, put it)

Connect to the installation wizard by opening your browser to `instance_address/wizard`, you should get this:
![wizard preview on localhost/wizard](assets/wizard-interface.png)

Then you need to paste your license key given by the technical team and click on *Go to configuration*

You must add the *public address* as `instance_address`. If you want to use a proxy in front of this instance (like Nginx), you have to configure the address here

NB: If you used the SSL setup, you must check the advanced configuration in *General/Websocket address* and use `wss` protocol instead of `ws`

#### Updating Configuration

You can modify the configuration after the first install, but you must restart all the apps manually after changing the configuration

```bash
docker-compose restart
```

## Update Procedure

Just run docker-compose up again and it will pull the latest backend image:

```bash
docker-compose pull keymetrics/km-wizard-dedicated keymetrics/km-api-dedicated keymetrics/noex-enterprise
docker-compose restart
```

A downtime of around 30 seconds maximum will happen, but don't worry all agent will keep packet and wait for the installation to be online.
