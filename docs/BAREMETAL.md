# PM2 EE Baremetal deployment

## Requirements

Install Docker & Docker compose (minimum required version is 1.19.0) in your host machine:

```bash
$ sudo wget -qO- https://get.docker.com/ | sh
$ sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

Then make sure you have logged-in on the hub to be able to pull the private images:

```bash
$ docker login
```

## Steps to Install

1. Get the docker-compose.yml example file:

```bash
$ wget https://raw.githubusercontent.com/keymetrics/on-premise/master/docker/docker-compose.yml
```

2. Start it:

```bash
$ docker-compose up -d
```

Check the logs via:

```bash
$ docker-compose logs
```

*In the beginning some connections errors might appears but it's not critical (elasticsearch take few seconds to boot so the backend will restart for few seconds then connect when his ready)*

## Update Procedure

Just run docker-compose up again and it will pull the latest backend image:

```bash
$ docker-compose pull km-api km-front
$ docker-compose restart km-api km-front
```

A downtime of around 30 seconds maximum will happen.
