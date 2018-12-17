# PM2 On Premise (Helm chart for K8S)

PM2 On premise installation for K8S

## Introduction
This chart bootstraps a PM2-On-Premise deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
- PV provisioner
- Ingress manager
- Regcred with read access to **Keymetrics** images

## Install the Chart
```bash
helm install . --name my-release --set pullSecret=regcred --ingress=true --ingress.hosts[]=
```

## Uninstalling the Chart
To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration
| Parameter                               | Description                                                                                  | Default                                     |
| --------------------------------------- | -------------------------------------------------------------------------------------------- | ------------------------------------------- |
| `imageApi` | API image | `keymetrics/km-api-dedicated` |
| `imageTagApi` | API image tag | `latest` |
| `imageFront` | Frontend image | `keymetrics/noex-enterprise` |
| `imageTagFront` | Front image tag | `latest` |
| `imageWizard` | Wizard image (used only at installation) | `keymetrics/km-wizard-dedicated` |
| `imageTagWizard` | Wizard image tag | `latest` |
| `pullSecret` | Name of docker registry secret | `regcred` |
| `pullPolicy` | Pull policy of containers | `IfNotPresent` |
| `nodeEnv` | Environment used for applications | `dedicated` |
| `ingress.enabled` | Enable ingress controller resource | `false` |
| `ingress.annotations` | Ingress annotations | {} |
| `ingress.hosts[0]` | Ingres hostname | `pm2-on-premise.local` |
| `ingress.tls` | Ingress TLS configuration | `[]` |
| `debug` | Activate logs | `false` |


Databases images are stables one (with hard coded versions)
