# Assume Role Policy document for EC2
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role Definition
resource "aws_iam_role" "backend" {
  name = "${var.environment}-backend"
  path = "/keymetrics/"
  
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

# Log Writing Policy document
data "aws_iam_policy_document" "allow_log_writing" {
  statement {
    actions = [
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:*:log-group:${aws_cloudwatch_log_group.keymetrics.name}:*"
    ]
  }
}

# Log Writing Policy
resource "aws_iam_policy" "allow_log_writing" {
  name        = "allow-log-writing"
  path        = "/keymetrics/"
  description = "Allow EC2 instance to submit logs to CloudWatch"

  policy ="${data.aws_iam_policy_document.allow_log_writing.json}"
}

# Attach Log Policy to Role
resource "aws_iam_role_policy_attachment" "backend_logs" {
  role       = "${aws_iam_role.backend.name}"
  policy_arn = "${aws_iam_policy.allow_log_writing.arn}"
}

# EC2 Instance Profile for Backend
resource "aws_iam_instance_profile" "backend" {
  name  = "keymetrics-${var.environment}-backend"
  role = "${aws_iam_role.backend.name}"
}
