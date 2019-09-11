# PM2 Enterprise On-Premise

- [Deploy to VM or Baremetal Machines](https://github.com/keymetrics/on-premise/blob/master/docs/BAREMETAL.md)

For any questions or assistance, contact us at tech@keymetrics.io

## Ressources requirements

In terms of the requirements itself, it really depends of how much agents you will need to connect.

- For 1 to 100 agents you will need a 4 CPUs, 8gb RAM and 100GB SSD machine.
- For 100 to 300 agents you will need a 8 CPUs, 16gb RAM and 256GB SSD machine. 
- For 300 to 500 agents you will need a 8/12 CPUs, 32gb RAM and 256GB SSD machine. 

Approximate resource usage break up for 500 agents in average (maximum ~1000 in burst):
- Elasticsearch (that would be the biggest VM that you will need, we advise to use 16G of RAM for it and at least 4 CPU and a good persistent storage, if possible SSD)
- Redis (at least 4G of RAM and 1 CPU)
- Mongodb (500Mb of RAM and 1 CPU is enough and persistent storage)
- For the applications themselves, we advise at least 10G of RAM and 12 CPU for all applications.

## Issues

- Sales: sales@keymetrics.io
- Technical: tech@keymetrics.io
