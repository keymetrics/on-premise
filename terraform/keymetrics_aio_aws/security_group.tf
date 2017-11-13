# ES
resource "aws_security_group" "elasticsearch" {
  name = "keymetrics-elasticsearch"
  description = "SecurityGroup for Keymetrics Elasticsearch"

  # Allow all outbound connections
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "keymetrics-elasticsearch"
    Environment = "${var.environment}"
  }
}

# Allow backend to connect
resource "aws_security_group_rule" "es_allow_backend" {
  type            = "ingress"
  from_port       = 9200
  to_port         = 9200
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.backend.id}"
  
  security_group_id = "${aws_security_group.elasticsearch.id}"
}

# REDIS
resource "aws_security_group" "redis" {
  name = "keymetrics-redis"
  description = "SecurityGroup for Keymetrics Redis"

  # Allow backend to connect
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_groups = ["${aws_security_group.backend.id}"]
  }
  
  tags {
    Name = "keymetrics-redis"
    Environment = "${var.environment}"
  }
}

# MONGO
resource "aws_security_group" "mongodb" {
  name = "keymetrics-mongodb"
  description = "SecurityGroup for Keymetrics Mongodb"

  # Allow all outbond connections
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "keymetrics-mongodb"
    Environment = "${var.environment}"
  }
}

# Allow backend to connect
resource "aws_security_group_rule" "mongodb_allow_backend" {
  type            = "ingress"
  from_port       = 27017
  to_port         = 27017
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.backend.id}"
  
  security_group_id = "${aws_security_group.mongodb.id}"
}

# BACKEND
resource "aws_security_group" "backend" {
  name = "keymetrics-backend"
  description = "SecurityGroup for Keymetrics Backend"

  # Allow all outbond connections
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  tags {
    Name = "keymetrics-backend"
    Environment = "${var.environment}"
  }
}

# Allow public connection to Backend web server
resource "aws_security_group_rule" "allow_web" {
  count = "${var.make_backend_web_public ? 1 : 0}"
  
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]
  
  security_group_id = "${aws_security_group.backend.id}"
}
