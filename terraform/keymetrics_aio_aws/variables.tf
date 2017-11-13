variable "key_name" {
  description = "Name of AWS key pair (name)"
}

variable "vpc_id" {
  description = "Desired VPC used to launch EC2 images (id)"
}

variable "keymetrics_key" {
  description = "Keymetrics key used to validate the instance"
}

variable "environment" {
  description = "Environment name (used to tag the machines)"
}

variable "internal_tld" {
  description = "TLD used for internal DNS zone without starting and ending '.' (ex: 'lan', 'local'...)"
  default = "keymetrics"
}

variable "public_host_address" {
  description = "Public DNS record that will point to Keymetric frontend"
  default = ""
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

variable "mongodb_instance_type" {
  description = "EC2 Instance Type to use for MongoDB"
  default = "t2.micro"
}

variable "elasticsearch_instance_type" {
  description = "EC2 Instance Type to use for Elasticsearch"
  default = "r3.xlarge"
}

variable "backend_instance_type" {
  description = "EC2 Instance Type to use for Keymetrics"
  default = "c4.xlarge"
}

variable "redis_instance_type" {
  description = "EC2 Instance Type to use for Redis"
  default = "t2.micro"
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

variable "make_backend_web_public" {
  description = "Make the HTTP Server of the backend public (0.0.0.0/32)"
  default = true
}
