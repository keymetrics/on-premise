# PM2 On Premise (Kubernetes without dependency)

## Info

Generated helm files in releases of this repo doesn't have any databases created. You should change the host for ingresses.

If you need more modification, check [#install-tools-to]

## Prepare cluster

### Add registry credential with read rights on Keymetrics organisation

[https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#registry-secret-existing-credentials)

```bash
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=<path/to/.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson
```

## Charting library (helm)

### Use tools

We will use a docker image for that, it's easier!

```bash
docker run -v `pwd`:/data --entrypoint /bin/sh -it alpine/helm
```

### Get chart requirements (if it doesn't exist)

```bash
helm dependency update
```

### Generate template from Helm Chart

Run `template.sh`

## Install generated files

```bash
kubectl --namespace pm2-on-premise create -f helm-generated/*
```