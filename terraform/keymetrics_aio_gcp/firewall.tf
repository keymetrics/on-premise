data "google_compute_network" "network-to-use" {
  name = "${var.network_name}"
}

resource "google_compute_firewall" "backend_public_access" {
  name    = "keymetrics-backend-${var.environment}"
  network = "${data.google_compute_network.network-to-use.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "43554", "3900"]
  }

  target_tags = ["keymetrics-backend-${var.environment}"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "backend_redis_access" {
  name    = "keymetrics-redis-${var.environment}"
  network = "${data.google_compute_network.network-to-use.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  target_tags = ["keymetrics-redis-${var.environment}"]
  source_tags = ["keymetrics-backend-${var.environment}"]
}

resource "google_compute_firewall" "backend_elasticsearch_access" {
  name    = "keymetrics-elasticsearch-${var.environment}"
  network = "${data.google_compute_network.network-to-use.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["9200"]
  }

  target_tags = ["keymetrics-elasticsearch-${var.environment}"]
  source_tags = ["keymetrics-backend-${var.environment}"]
}

resource "google_compute_firewall" "backend_mongodb_access" {
  name    = "keymetrics-mongodb-${var.environment}"
  network = "${data.google_compute_network.network-to-use.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  target_tags = ["keymetrics-mongodb-${var.environment}"]
  source_tags = ["keymetrics-backend-${var.environment}"]
}
