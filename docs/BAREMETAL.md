# PM2 EE Baremetal deployment

## Requirements

Install Docker & Docker compose:

```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
```

## Steps to Install

1. Get the [docker-compose.yml file](https://github.com/keymetrics/on-premise/blob/master/docker/docker-compose.yml)
2. Edit the docker-compose.yml:

`KM_DEDICATED_KEY` with the license key provided<br/>
`KM_SMTP_*` with the SMTP informations<br/>
`KM_SITE_URL` with the url that will be bound to the backend (or the ip address directly)<br/>

Then run the docker-compose.yml file:

```bash
$ docker-compose up
```

*Some ES errors might appears but it's not critical (time for the backend to connect to ES)*

## Update Procedure

Just run docker-compose up again and it will pull the latest backend image:

```bash
$ docker-compose up
```

A downtime of around 30 seconds maximum will happen.
