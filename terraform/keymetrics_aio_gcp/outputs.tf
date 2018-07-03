# Firewall

output "redis_fw_tag_name" {
  value = "keymetrics-redis-${var.environment}"
}

output "backend_fw_tag_name" {
  value = "keymetrics-backend-${var.environment}"
}

output "elasticsearch_fw_tag_name" {
  value = "keymetrics-elasticsearch-${var.environment}"
}

output "mongodb_fw_tag_name" {
  value = "keymetrics-mongodb-${var.environment}"
}

