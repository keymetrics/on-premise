provider "kubernetes" {
  host                   = "${google_container_cluster.default.endpoint}"
  token                  = "${data.google_client_config.current.access_token}"
  client_certificate     = "${base64decode(google_container_cluster.default.master_auth.0.client_certificate)}"
  client_key             = "${base64decode(google_container_cluster.default.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)}"
}

resource "kubernetes_secret" "regcred" {
  metadata {
    name = "regcred"
  }

  data {
    ".dockerconfigjson" = <<EOF
{
  "auths": {
    "https://index.docker.io/v1/": {
      "username": "${var.docker_user}",
      "password": "${var.docker_pw}",
      "email": "${var.docker_email}",
      "auth": "${base64encode(format("%s:%s", var.docker_user, var.docker_pw))}"
    }
  }
}
EOF
  }

  type = "kubernetes.io/dockerconfigjson"
}