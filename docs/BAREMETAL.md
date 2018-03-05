# PM2 EE Baremetal deployment

1. Get the [docker-compose.yml file](https://github.com/keymetrics/on-premise/blob/master/docker/docker-compose.yml)
2. Edit the docker-compose.yml:

`KM_DEDICATED_KEY` with the license key provided

`KM_SMTP_*` with the SMTP informations

`KM_SITE_URL` with the url that will be bound to the backend

Then run the docker-compose.yml file:

```bash
$ docker-compose up
```

*Some ES errors might appears but it's not critical (time for the backend to connect to ES)*

