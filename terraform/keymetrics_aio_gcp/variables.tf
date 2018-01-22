variable "environment" {
  description = "Environment name for deployment (qa, prod, dev, etc.)"
}

variable "project" {
  description = "GCP Project Name"
}

variable "pm2_backend_logfiles" {
  description = "Log files fromt the backend to publish on CloudWatch Logs"
  default = [
    "AXM-INTERACTION-APP-out.log",
    "AXM-INTERACTION-APP-error.log",
    "AXM-LIMIT-WORKER-out.log",
    "AXM-LIMIT-WORKER-error.log",
    "AXM-NOTIFICATION-out.log",
    "AXM-NOTIFICATION-error.log",
    "AXM-REALTIME-out.log",
    "AXM-REALTIME-error.log",
    "AXM-REVERSE-INTERACTION-out.log",
    "AXM-REVERSE-INTERACTION-error.log",
    "AXM-WEB-API-out.log",
    "AXM-WEB-API-error.log"
  ]
}

variable "public_host_address" {
  description = "Public DNS record that will point to Keymetric frontend"
  default = ""
}

variable "smtp_username" {
  description = "SMTP Server username to use for sending emails"
}

variable "smtp_password" {
  description = "SMTP Server password to use for sending emails"
}

variable "smtp_host" {
  description = "SMTP Server hostname to use for sending emails"
}

variable "smtp_sender" {
  description = "Email Address used as 'from:' for notifications and post-install message."
}

variable "keymetrics_key" {
  description = "Keymetrics key used to validate the instance"
}

variable "network_name" {
  description = "GCP Network to use for deployment."
}

variable "mongodb_instance_type" {
  description = "GCP instance type for MongoDB."
  default = "n1-standard-1"
}

variable "elasticsearch_instance_type" {
  description = "GCP instance type for ElasticSearch."
  default = "n1-standard-1"
}

variable "redis_instance_type" {
  description = "GCP instance type for Redis."
  default = "n1-standard-1"
}

variable "backend_instance_type" {
  description = "GCP instance type for Backend."
  default = "n1-standard-1"
}

variable "elasticsearch_disk_size" {
  description = "Persistant disk size for Elasticsearch"
  default = "100"
}

variable "mongodb_disk_size" {
  description = "Persistant disk size for MongoDB"
  default = "30"
}
