# Specify the provider and access details
provider "aws" {
  region = "eu-west-1"
}

# Example/Test use(s) of keymetrics_aio_aws module
module "example_keymetrics_setup" {
  source  = "keymetrics_aio_aws"

  key_name = "admin"
  vpc_id = "vpc-xxxxxxxx"
  keymetrics_key = "...

  environment = "example"

  smtp_host = "smtp.mailgun.org"
  smtp_username = "postmaster@example.com"
  smtp_password = "XXX"
  smtp_sender = "keymetrics@example.com"
  
  public_host_address = "our-keymetrics-public-subdomain.example.com"
}

