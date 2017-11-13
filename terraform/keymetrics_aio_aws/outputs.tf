# IP

output "backend_public_ip" {
  value = "${aws_eip.backend.public_address}"
}

# Records

output "backend_private_address" {
  value = "${aws_route53_record.backend.fqdn}"
}

output "redis_private_address" {
  value = "${aws_route53_record.redis.fqdn}"
}

output "mongodb_private_address" {
  value = "${aws_route53_record.mongo.fqdn}"
}

output "elasticsearch_private_address" {
  value = "${aws_route53_record.es.fqdn}"
}

# Zone

output "private_zone_id" {
  value = "${aws_route53_zone.internal.id}"
}

# SG

output "backend_securitygroup_name" {
  value = "${aws_security_group.backend.name}"
}

output "redis_securitygroup_name" {
  value = "${aws_security_group.redis.name}"
}

output "elasticsearch_securitygroup_name" {
  value = "${aws_security_group.elasticsearch.name}"
}

output "mongodb_securitygroup_name" {
  value = "${aws_security_group.mongodb.name}"
}
