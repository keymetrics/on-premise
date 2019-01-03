# Terraform GCE K8S

## Download helm dependencies

## Init service account
https://cloud.google.com/docs/authentication/production
`export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/[FILE_NAME].json"`

## Add Terraform Helm provider
```shell
(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/mcuadros/terraform-provider-helm/releases/download/v0.5.1/terraform-provider-helm_v0.5.1_$(uname | tr '[:upper:]' '[:lower:]')_amd64.tar.gz" &&
  tar -xvf terraform-provider-helm*.tar.gz &&
  mkdir -p ~/.terraform.d/plugins/ &&
  mv terraform-provider-helm*/terraform-provider-helm ~/.terraform.d/plugins/
)
```