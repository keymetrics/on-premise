# Elasticache Redis Instance
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "keymetrics-redis"
  engine               = "redis"
  node_type            = "cache.${var.redis_instance_type}"
  port                 = 6379
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"

  security_group_ids   = ["${aws_security_group.redis.id}"]

  tags {
    Environment = "${var.environment}"
  }
}
