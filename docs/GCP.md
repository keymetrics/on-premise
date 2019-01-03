# Keymetrics deployment on GCP

Documentation about how to deploy the keymetrics on-premise version on GCP

### Requirements

In the following examples, we assume that you already have a fully working Terraform project. You can follow the [`Getting Started`](https://www.terraform.io/intro/getting-started/install.html) guide on the official website [here](https://www.terraform.io/intro/getting-started/install.html).

## Setup steps

### 1. Init service account
https://cloud.google.com/docs/authentication/production
`export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/[FILE_NAME].json"`

### 2. Add Terraform Helm provider
```shell
(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/mcuadros/terraform-provider-helm/releases/download/v0.5.1/terraform-provider-helm_v0.5.1_$(uname | tr '[:upper:]' '[:lower:]')_amd64.tar.gz" &&
  tar -xvf terraform-provider-helm*.tar.gz &&
  mkdir -p ~/.terraform.d/plugins/ &&
  mv terraform-provider-helm*/terraform-provider-helm ~/.terraform.d/plugins/
)
```

### 3. Set the module variables

The following variables are available:
- **google_project**: [*Required*] Name of your google project
- **docker_user**: [*Required*] Docker hub username
- **docker_pw**: [*Required*] Docker password/api key
- **docker_email**: [*Required*] Docker email/api key
- **acme_email**: [*Required*] Email for Let's Encrypt certificate request
- **custom_domain**: Custom host for ingresses


### 4. `Plan` and `Apply` your changes using the `terraform` command

Run `terraform plan` and make sure no error shows up in the logs.

You can then run `terraform apply` in order to make terraform created the infrastructure on your GCP Project.

## Extra configuration depending of your own existing infrastructure

### Add a sub-domain pointing to Keymetrics instance

By default, Keymetrics instance is using an External IP addresses to be publicly available to its users. If you want to use it with a domain, you __first__ need to set `public_host_address` variable to the domain to use and then create a `A` record pointing to its public External IP addresses.

*__Warning: Once deployed with either the public IP or a domain, it's not possible to change it without fully dropping the mongodb database.__*

### Allow your apps to connect to Keymetrics APIs

By default, Keymetrics instance only accept connection on port `443/tcp` from `0.0.0.0/32`. In order to let your applications talk with the Keymetrics backend, you need to allow their security groups to connected to Keymetrics instance (proxy) on port `443/tcp`.


# GCE K8S manual install
1. Create GCE cluster
At least 3 nodes and 6Gb/Node,
disable Google Load Balancer (we'll use Nginx Controller)

2. Create helm user
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```

3. Helm init with serviceaccount
`helm init --service-account tiller`

4. Add regcred
`kubectl --namespace helm create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username={{user}} --docker-password={{password}} --docker-email={{email}}`

5. Helm install
`helm --namespace helm install . --set ingress.enabled=true --set ingress.hosts[0]=cl2.km.io --set pullPolicy=Always`

6. Ingress
Example with a Nginx DeamonSet (but you can use whatever you want)
`helm --namespace nginx install stable/nginx-controller --set controller.kind=DaemonSet --set controller.daemonset.useHostPort=true`

7. DNS
Configure your DNS to your nodes
