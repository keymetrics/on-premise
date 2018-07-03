# ELASTICSEARCH

data "template_file" "setup_elasticsearch" {
  template = "${file("${path.module}/setup_elasticsearch.tpl")}"

  vars {
    cluster_name = "keymetrics-${var.environment}"
  }
}

resource "google_compute_instance" "elasticsearch" {
  name         = "km-elasticsearch-${var.environment}"
  machine_type = "${var.elasticsearch_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  tags = ["keymetrics-elasticsearch-${var.environment}", "keymetrics-${var.environment}"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.ubuntu.name}"
    }
  }

  attached_disk {
    source      = "${google_compute_disk.elasticsearch_data.name}"
    device_name = "data"
  }

  network_interface {
    network       = "${var.network_name}"
    access_config = {}
  }

  metadata {
    project = "keymetrics"
    service = "elasticsearch"
  }

  metadata_startup_script = "${data.template_file.setup_elasticsearch.rendered}"

  service_account {
    email  = "${google_service_account.keymetrics-backend-logs.email}"
    scopes = ["cloud-platform"]
  }
}

# MONGODB

data "template_file" "setup_mongodb" {
  template = "${file("${path.module}/setup_mongodb.tpl")}"
}

resource "google_compute_instance" "mongodb" {
  name         = "km-mongodb-${var.environment}"
  machine_type = "${var.mongodb_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  tags = ["keymetrics-mongodb-${var.environment}", "keymetrics-${var.environment}"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.ubuntu.name}"
    }
  }

  attached_disk {
    source      = "${google_compute_disk.mongodb_data.name}"
    device_name = "data"
  }

  network_interface {
    network       = "${var.network_name}"
    access_config = {}
  }

  metadata {
    project = "keymetrics"
    service = "mongodb"
  }

  metadata_startup_script = "${data.template_file.setup_mongodb.rendered}"

  service_account {
    email  = "${google_service_account.keymetrics-backend-logs.email}"
    scopes = ["cloud-platform"]
  }
}

# REDIS

data "template_file" "setup_redis" {
  template = "${file("${path.module}/setup_redis.tpl")}"
}

resource "google_compute_instance" "redis" {
  name         = "km-redis-${var.environment}"
  machine_type = "${var.redis_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  tags = ["keymetrics-redis-${var.environment}", "keymetrics-${var.environment}"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.ubuntu.name}"
    }
  }

  network_interface {
    network       = "${var.network_name}"
    access_config = {}
  }

  metadata {
    project = "keymetrics"
    service = "redis"
  }

  metadata_startup_script = "${data.template_file.setup_redis.rendered}"

  service_account {
    email  = "${google_service_account.keymetrics-backend-logs.email}"
    scopes = ["cloud-platform"]
  }
}

# BACKEND

data "template_file" "setup_backend" {
  template = "${file("${path.module}/setup_backend.tpl")}"

  vars {
    # ElasticSearch Address
    es_private_ip = "km-elasticsearch-${var.environment}.${data.google_compute_zones.available.names[0]}.c.${var.project}.internal"

    # MongoDB Address
    mongodb_private_ip = "km-mongodb-${var.environment}.${data.google_compute_zones.available.names[0]}.c.${var.project}.internal"

    # Redis Address
    redis_private_ip = "km-redis-${var.environment}.${data.google_compute_zones.available.names[0]}.c.${var.project}.internal"

    # Files to log in CloudWatch Logs
    log_files = "${join(" ", var.pm2_backend_logfiles)}"

    # Misc vars
    environment = "${var.environment}"
  }
}

resource "google_compute_instance" "backend" {
  name         = "km-backend-${var.environment}"
  machine_type = "${var.backend_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  tags = ["keymetrics-backend-${var.environment}", "keymetrics-${var.environment}"]

  boot_disk {
    initialize_params {
      image = "gcr.io/dedicated-keymetrics/km-api:latest"
    }
  }

  network_interface {
    network = "${var.network_name}"

    access_config {
      nat_ip = "${google_compute_address.public_ip.address}"
    }
  }

  metadata {
    project            = "keymetrics"
    service            = "backend"
    serial-port-enable = 1
  }

  metadata_startup_script = "${data.template_file.setup_backend.rendered}"

  service_account {
    email  = "${google_service_account.keymetrics-backend-logs.email}"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "wizard" {
  name         = "km-wizard-${var.environment}"
  machine_type = "${var.backend_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  tags = ["keymetrics-wizard-${var.environment}", "keymetrics-${var.environment}"]

  boot_disk {
    initialize_params {
      image = "dedicated-keymetrics/km-wizard"
    }
  }

  network_interface {
    network = "${var.network_name}"

    access_config {
      nat_ip = "${google_compute_address.public_ip.address}"
    }
  }

  metadata {
    project            = "keymetrics"
    service            = "wizard"
    serial-port-enable = 1
  }

  metadata_startup_script = "${data.template_file.setup_backend.rendered}"

  service_account {
    email  = "${google_service_account.keymetrics-backend-logs.email}"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "frontend" {
  name         = "km-frontend-${var.environment}"
  machine_type = "${var.backend_instance_type}"
  zone         = "${data.google_compute_zones.available.names[0]}"

  tags = ["keymetrics-frontend-${var.environment}", "keymetrics-${var.environment}"]

  boot_disk {
    initialize_params {
      image = "dedicated-keymetrics/km-front"
    }
  }

  network_interface {
    network = "${var.network_name}"

    access_config {
      nat_ip = "${google_compute_address.public_ip.address}"
    }
  }

  metadata {
    project            = "keymetrics"
    service            = "frontend"
    serial-port-enable = 1
  }

  service_account {
    email  = "${google_service_account.keymetrics-backend-logs.email}"
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_url_map" "loadbalancer" {
  name        = "loadbalancer"
  description = "balance request between services"

  default_service = "${google_compute_instance.frontend.self_link}"

  path_matcher {
    name            = "keymetrics"
    default_service = "${google_compute_instance.frontend.self_link}"

    path_rule {
      paths   = ["/primus"]
      service = "${google_compute_instance.backend.self_link}"
    }

    path_rule {
      paths   = ["/api/oauth"]
      service = "${google_compute_instance.backend.self_link}"
    }

    path_rule {
      paths   = ["/api"]
      service = "${google_compute_instance.backend.self_link}"
    }

    path_rule {
      paths   = ["/wizard"]
      service = "${google_compute_instance.wizard.self_link}"
    }

    path_rule {
      paths   = ["/interaction"]
      service = "${google_compute_instance.backend.self_link}"
    }
  }
}
