# PM2 EE Baremetal deployment

## Requirements

Install Docker & Docker compose (minimum required version is 1.19.0):

```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
```

## Steps to Install

1. Get the docker-compose.yml file:

```bash
$ wget https://raw.githubusercontent.com/keymetrics/on-premise/master/docker/docker-compose.yml
```

2. Edit the docker-compose.yml:

`KM_DEDICATED_KEY` with the license key provided<br/>
`KM_SMTP_*` with the SMTP informations (for receiving email notification/alerts)<br/>
`KM_SITE_URL` with the url that will be bound to the backend (or the ip address directly)<br/>

*For full information about the configuration flag, check the related [documentation](https://github.com/keymetrics/on-premise/blob/master/docs/BACKEND.md#keymetrics-core-documentation)*

Once you have configured the docker-compose.yml file, run it:

```bash
$ docker-compose up
```

*Some ES errors might appears but it's not critical (delay for the backend to connect to ES)*

## Update Procedure

Just run docker-compose up again and it will pull the latest backend image:

```bash
$ docker-compose up
```

A downtime of around 30 seconds maximum will happen.
