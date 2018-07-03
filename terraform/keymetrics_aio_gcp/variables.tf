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
    "AXM-OAUTH-out.log",
    "AXM-OAUTH-error.log",
    "AXM-PROXY-out.log",
    "AXM-PROXY-error.log",
    "AXM-DIGESTERS-out.log",
    "AXM-DIGESTERS-error.log",
    "AXM-WEB-API-out.log",
    "AXM-WEB-API-error.log"
  ]
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
