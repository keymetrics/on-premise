# PM2 Enterprise Edition

<center>
  <img width="400" src="https://i.imgur.com/rSr48fK.png"/>
  </center> 

## Before Provisioning

1. Create an account on [https://enterprise.keymetrics.io/](https://enterprise.keymetrics.io/)
1. Send your email address you registered with and your [provider informations](https://github.com/keymetrics/on-premise/blob/master/docs/PROVIDERS.md) to aris@keymetrics.io
1. Then you will receive the License by email after validation and you will be ready to provision PM2 EE

## Provisioning

Provisioning PM2 EE Monitoring:
- [On Baremetal servers with Docker Compose](https://github.com/keymetrics/on-premise/blob/master/docs/BAREMETAL.md)
- [On Amazon AWS with Terraform](https://github.com/keymetrics/on-premise/blob/master/docs/AWS.md)
- [On Kubernetes with HELM](https://github.com/keymetrics/on-premise/blob/master/docs/HELM.md)
- [On GCP with Terraform](https://github.com/keymetrics/on-premise/blob/master/docs/GCP.md)

Specific documentation: [here](https://github.com/keymetrics/on-premise/blob/master/docs/BACKEND.md)

## After Provisioning

Go to your the public address that you configured when you did the provisioning (via `KM_SITE_URL`), then create an account and you are ready to go.

## Updating

###### AWS

If you deployed with terraform (and we encourage you to so), you should be able to use `terraform apply`, it will automaticly get the latest AMI and if needed, update the running instance.

###### Docker

If you deployed with Docker, you will just need to:

```bash
$ docker-compose pull km-api km-front
$ docker-compose restart km-api km-front
```

###### Other

If you want some advises on how to update if you deployed it yourself as you wanted, you can ask us at tech@keymetrics.io or on slack

## Any issues?

- Slack: [https://keymetrics-team.slack.com/](https://keymetrics-team.slack.com/)
- Sales support: sales@keymetrics.io
- Technical support: tech@keymetrics.io
