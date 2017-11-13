# Private DNS zone for Keymetrics resources (EC2 Instances + Redis)
resource "aws_route53_zone" "internal" {
  name = "${var.environment}.${var.internal_tld}"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

# BACKEND

resource "aws_route53_record" "backend" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "backend"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.backend.private_ip}"]
}

resource "aws_route53_record" "backend-to-front-cname" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "frontend"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_route53_record.backend.fqdn}"]
}

# MONGO

resource "aws_route53_record" "mongo" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "mongodb"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.mongodb.private_ip}"]
}

# ES

resource "aws_route53_record" "es" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "elasticsearch"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.elasticsearch.private_ip}"]
}

# REDIS

resource "aws_route53_record" "redis" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "redis"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_elasticache_cluster.redis.cache_nodes.0.address}"]
}

