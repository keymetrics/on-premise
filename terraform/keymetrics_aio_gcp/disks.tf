resource "google_compute_disk" "mongodb_data" {
  name  = "keymetrics-mongodb-data-${var.environment}"
  type  = "pd-standard"
  zone  = "${data.google_compute_zones.available.names[0]}"

  size = "${var.mongodb_disk_size}"
  
  labels {
    environment = "keymetrics-mongodb-data-${var.environment}"
  }
}

resource "google_compute_disk" "elasticsearch_data" {
  name  = "keymetrics-elasticsearch-data-${var.environment}"
  type  = "pd-standard"
  zone  = "${data.google_compute_zones.available.names[0]}"

  size = "${var.elasticsearch_disk_size}"
  
  labels {
    environment = "keymetrics-elasticsearch-data-${var.environment}"
  }
}
