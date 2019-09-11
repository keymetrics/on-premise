# PM2 Enterprise On-Premise

- [Deploy to VM or Baremetal Machines](https://github.com/keymetrics/on-premise/blob/master/docs/BAREMETAL.md)

For any questions or assistance, contact us at tech@keymetrics.io

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
