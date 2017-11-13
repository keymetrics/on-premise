# Most recent image of the backend
data "aws_ami" "backend" {
  most_recent = true

  filter {
    name   = "name"
    values = ["km-api_*"]
  }

  owners = ["965529562887"] # Keymetrics
}

# Most recent image of Ubuntu 16.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical 
}
