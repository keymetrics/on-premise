data "google_compute_image" "km-api" {
  family = "km-api"
}

data "google_compute_image" "ubuntu" {
  family = "ubuntu-1604-lts"
  project = "ubuntu-os-cloud"
}
