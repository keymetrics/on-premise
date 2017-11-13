# Logs Group in CloudWatch Logs
resource "aws_cloudwatch_log_group" "keymetrics" {
  name = "/keymetrics/${var.environment}"

  tags {
    Environment = "${var.environment}"
  }
}

# Log Entry in the Log Group above for each file to monitor
resource "aws_cloudwatch_log_stream" "pm2_backend_log_entry" {
  # Cycle through the list of files
  count = "${length(var.pm2_backend_logfiles)}"

  name           = "${element(var.pm2_backend_logfiles, count.index)}"
  log_group_name = "${aws_cloudwatch_log_group.keymetrics.name}"
}
