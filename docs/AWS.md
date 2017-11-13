## Keymetrics deployment on AWS

Documentation about how to deploy the keymetrics on-premise version on AWS

### Requirements

In the following examples, we assume that you already have a fully working Terraform project. You can follow the [`Getting Started`](https://www.terraform.io/intro/getting-started/install.html) guide on the official website [here](https://www.terraform.io/intro/getting-started/install.html).

### 1. Adding the module to your terraform project

There's two options available in order to use our terraform module in your project. 
- Link the module's git repository address in your terraform module definition
- Clone the repository and set the source variable of your module definiton to the correct path on your drive.

##### Without cloning the repository

When defining your module definition, use the following `source` value:
- `git@github.com:keymetrics/on-premise.git//terraform/keymetrics_aio_aws`

Example: 

```
module "keymetrics" {
  source  = "git@github.com:keymetrics/on-premise.git//terraform/keymetrics_aio_aws"
  ...
}
```

##### By cloning the repository

Start by cloning the repository in your project directory using the git command:
- `git clone git@github.com:keymetrics/on-premise.git keymetrics-on-premise`

Define the `kemetrics` module using the relative path.
Example:

```
module "keymetrics" {
  source  = "keymetrics-on-premise/terraform/keymetrics_aio_aws"
  ...
}
```

### 2. Set the module variables

The variables are set inside the module definition and allow you to chose how the module is going to setup your infrastructe and which external services are going to be used.

Example of module with variables:

```
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
```

The following variables are available:
- **key_name**: [*Required*] The name of the SSH Public key to use.
- **vpc_id**: [*Required*] The id of the VPC hosting the EC2 Instances.
- **keymetrics_key**: [*Required*] Keymetrics License Key.
- **environment**: [*Required*] The name of your environment (ex: `qa`, `prod`, `prod-1`, etc.).
- **smtp_username**: [*Required*] Username used to connect to the SMTP server.
- **smtp_password**: [*Required*] Password used to connect to the SMTP server.
- **smtp_host**: [*Required*] Hostname of the SMTP server.
- **smtp_sender**: [*Required*] Email address used to send emails.
- **internal_tld**: TLD used for internal DNS zone (ex: `lan`, `local`, `km`, etc)
- **public_host_address**: Public domain pointing to Keymetrics HTTP Server (if empty, the public IP will be used).
- **mongodb_instance_type**: EC2 Instance type to use for MongoDB Instance.
- **elasticsearch_instance_type**: EC2 Instance type to use for ElasticSearch Instance.
- **redis_instance_type**: EC2 Instance type to use for Redis Instance.
- **backend_instance_type**: EC2 Instance type to use for Backend Instance.
- **make_backend_web_public**: If set to false, prevent the creation of a security group rule opening the port 80/tcp of the backend instance.

For more informations, please check the [`variables.tf`](https://github.com/keymetrics/on-premise/blob/master/terraform/keymetrics_aio_aws/variables.tf) file in the module

### 3. `Plan` and `Apply` your changes using the `terraform` command

Run `terraform plan -target=module.example_keymetrics_setup -out tfout` and make sure no error shows up in the logs.

You can then run `terraform apply tfout` in order to make terraform created the infrastructure on your AWS Account.

