# Fetch the current AWS Region
data "aws_region" "current" {
  current = true
}
