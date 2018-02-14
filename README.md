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
- [On Amazon AWS with Terraform](https://github.com/keymetrics/on-premise/blob/master/docs/AWS.md)
- [On Kubernetes with HELM](https://github.com/keymetrics/on-premise/blob/master/docs/HELM.md)
- [On GCP with Terraform](https://github.com/keymetrics/on-premise/blob/master/docs/GCP.md)
- [On Baremetal servers]() (WIP)

Specific documentation: [here](https://github.com/keymetrics/on-premise/blob/master/docs/BACKEND.md)

## After Provisioning

Go to your the public address that you configured when you did the priovisioning, then create an account and you are ready to go.

## Updating
###### AWS
If you deployed with terraform (and we encourage you to so), you should be able to use `terraform apply`, it will automaticly get the latest AMI and if needed, update the running instance.
###### Docker
If you deployed with Docker, you will just need to restart with the `docker-compose.yml` file and it will automacitly pull the newest image from the docker hub
###### Other
If you want some advises on how to update if you deployed it yourself as you wanted, you can ask us at tech@keymetrics.io or on slack

## Any issues?

- Slack: [https://keymetrics-team.slack.com/](https://keymetrics-team.slack.com/)
- Sales support: sales@keymetrics.io
- Technical support: tech@keymetrics.io
