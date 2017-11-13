# Setup script for ElasticSearch Cluster
data "template_file" "user_data_elasticsearch" {
  template = "${file("${path.module}/user_data_elasticsearch.tpl")}"
  
  vars {
    cluster_name = "keymetrics-${var.environment}"
  }
}

# EC2 ElasticSearch Instance
resource "aws_instance" "elasticsearch" {
  instance_type = "${var.elasticsearch_instance_type}"
  ami = "${data.aws_ami.ubuntu.image_id}"
  key_name = "${var.key_name}"

  user_data = "${data.template_file.user_data_elasticsearch.rendered}"
  
  tags {
    Name = "keymetrics-elasticsearch"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
  
  security_groups = ["${aws_security_group.elasticsearch.name}"]
}

# EC2 MongoDB Instance
resource "aws_instance" "mongodb" {
  instance_type = "${var.mongodb_instance_type}"
  ami = "${data.aws_ami.ubuntu.image_id}"
  key_name = "${var.key_name}"

  # Setup Script for MongoDB Server
  user_data = "${file("${path.module}/user_data_mongodb.tpl")}"
  
  tags {
    Name = "keymetrics-mongodb"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
  
  security_groups = ["${aws_security_group.mongodb.name}"]
}

# Setup Script for Keymetrics On-Premise
data "template_file" "user_data_backend" {
  template = "${file("${path.module}/user_data_backend.tpl")}"

  vars {
    # ElasticSearch Address
    es_private_id = "${aws_route53_record.es.fqdn}"
    # MongoDB Address
    mongodb_private_id = "${aws_route53_record.mongo.fqdn}"
    # Redis Address
    redis_private_ip = "${aws_route53_record.redis.fqdn}"
    # Keymetrics License Key
    keymetrics_key = "${var.keymetrics_key}"
    # Backend public IP or domain for HTTP redirections/url generation
    backend_public_ip = "${var.public_host_address == "" ? aws_eip.backend.public_ip : var.public_host_address}"
    # Files to log in CloudWatch Logs
    log_files = "${join(" ", var.pm2_backend_logfiles)}"

    # Use provided SMTP hostname or use AWS SES instead
    smtp_host = "${var.smtp_host}"
    # NOTE: If no SMTP hostname is provided, use the IAM User credentials created for SES.
    smtp_username = "${var.smtp_username}"
    smtp_password = "${var.smtp_password}"
    smtp_sender = "${var.smtp_sender}"

    # Misc vars
    region = "${data.aws_region.current.name}"
    environment = "${var.environment}"
  }
}

# EC2 Backend Instance
resource "aws_instance" "backend" {
  instance_type = "${var.backend_instance_type}"

  ami = "${data.aws_ami.backend.id}"

  # SSH Key
  key_name = "${var.key_name}"

  # Setup script
  user_data = "${data.template_file.user_data_backend.rendered}"

  security_groups = ["${aws_security_group.backend.name}"]

  iam_instance_profile = "${aws_iam_instance_profile.backend.id}"

  lifecycle {
    create_before_destroy = true
  }
  
  tags {
    Name = "keymetrics-core"
    Environment = "${var.environment}"
  }
}
