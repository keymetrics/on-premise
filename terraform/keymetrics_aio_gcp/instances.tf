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
    source = "${google_compute_disk.elasticsearch_data.name}"
    device_name = "data"
  }
   
  network_interface {
    network = "default"
    access_config = {}
  }

  metadata {
    project = "keymetrics"
    service = "elasticsearch"
  }

  metadata_startup_script = "${data.template_file.setup_elasticsearch.rendered}"
  
  service_account {
    email = "${google_service_account.keymetrics-backend-logs.email}"
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
    source = "${google_compute_disk.mongodb_data.name}"
    device_name = "data"
  }

  network_interface {
    network = "default"
    access_config = {}
  }

  metadata {
    project = "keymetrics"
    service = "mongodb"
  }

  metadata_startup_script = "${data.template_file.setup_mongodb.rendered}"
  
  service_account {
    email = "${google_service_account.keymetrics-backend-logs.email}"
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
    network = "default"
    access_config = {}
  }

  metadata {
    project = "keymetrics"
    service = "redis"
  }

  metadata_startup_script = "${data.template_file.setup_redis.rendered}"

  service_account {
    email = "${google_service_account.keymetrics-backend-logs.email}"
    scopes = ["cloud-platform"]
  }
}

# BACKEND

data "template_file" "setup_backend" {
  template = "${file("${path.module}/setup_backend.tpl")}"

  vars {
    # ElasticSearch Address
    es_private_ip =  "km-elasticsearch-${var.environment}.${data.google_compute_zones.available.names[0]}.c.${var.project}.internal"
    # MongoDB Address
    mongodb_private_ip = "km-mongodb-${var.environment}.${data.google_compute_zones.available.names[0]}.c.${var.project}.internal"
    # Redis Address
    redis_private_ip = "km-redis-${var.environment}.${data.google_compute_zones.available.names[0]}.c.${var.project}.internal"
    # Keymetrics License Key
    keymetrics_key = "${var.keymetrics_key}"
    # Backend public IP or domain for HTTP redirections/url generation
    backend_public_ip = "${var.public_host_address == "" ? google_compute_address.public_ip.address : var.public_host_address}"
    # Files to log in CloudWatch Logs
    log_files = "${join(" ", var.pm2_backend_logfiles)}"

    # Use provided SMTP hostname or use AWS SES instead
    smtp_host = "${var.smtp_host}"
    # NOTE: If no SMTP hostname is provided, use the IAM User credentials created for SES.
    smtp_username = "${var.smtp_username}"
    smtp_password = "${var.smtp_password}"
    smtp_sender = "${var.smtp_sender}"

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
      image = "${data.google_compute_image.km-api.name}"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.public_ip.address}"
    }
  }

  
  metadata {
    project = "keymetrics"
    service = "backend"
    serial-port-enable = 1
  }

  metadata_startup_script = "${data.template_file.setup_backend.rendered}"

  service_account {
    email = "${google_service_account.keymetrics-backend-logs.email}"
    scopes = ["cloud-platform"]
  }
}
