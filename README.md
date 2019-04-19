# PM2 Enterprise On-Premise

![PM2 Enterprise logo](https://pm2.io/_nuxt/img/f0a5c4e.svg)

## Overview

To use PM2 Enterprise on-premise, we provide Docker images containing all of our Application (front-end and back-end).

You only need to create a account on [hub.docker.com](https://hub.docker.com/), we allow this account to pull our images so you can install them in your servers.

If you have any questions :

- Sales: sales@keymetrics.io
- Technical: tech@keymetrics.io

## Deployments

To make it really easy to deploy our product, we also give you examples to deploy on different infrastructures:

- [Kubernetes with Helm](https://github.com/keymetrics/on-premise/blob/master/docs/HELM.md)
- [GKE (Google Cloud Platform Managed Kubernetes) with Terraform & Helm](https://github.com/keymetrics/on-premise/blob/master/docs/GCP.md)
- [Any docker servers with Docker Compose](https://github.com/keymetrics/on-premise/blob/master/docs/BAREMETAL.md)

Don't hesitate to ask questions to our tech team, we can provide assistance if you want to deploy it on another providers (like AWS).

## Ressources requirements

In terms of the requirements itself, it really depends of how much agents you will need to connect but if we aim for 500 agents in average (maximum ~1000 in burst):

- Elasticsearch (that would be the biggest VM that you will need, we advise to use 16G of RAM for it and at least 4 CPU and a good persistent storage, if possible SSD)
- Redis (at least 4G of RAM and 1 CPU)
- Mongodb (500Mb of RAM and 1 CPU is enough and persistent storage)
- For the applications themselves, we advise at least 10G of RAM and 12 CPU for all applications.

Note that it really depend on your use of the tool, we recommend to ask the technical team for a better estimate that suit your needs.
Also, this is an example, for the same load you could use the same server for both applications and the redis server.

## Issues

- Sales: sales@keymetrics.io
- Technical: tech@keymetrics.io
