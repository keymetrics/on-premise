// Configure the Google Cloud provider

variable "gcp_project" {
  # GCP Project where you want to deploy
  default = "MyProjectNameHere"
}

provider "google" {
  # Credential file from console (same as gcloud cli)
  credentials = "${file("account.json")}"
  project     = "${var.gcp_project}"  
  # Region you want to use
  region      = "us-central1"
}

module "gcp" {
  source = "./keymetrics_aio_gcp"
  environment = "dev"

  smtp_host = "smtp.mailgun.org"
  smtp_username = "postmaster@mydomain.tld"
  smtp_password = "XXXXXXXXXX"
  smtp_sender = "no-reply@mydomain.tld"

  project = "${var.gcp_project}"

  network_name = "default"
  
  keymetrics_key = "YOUR LICENSE HERE" 
}
