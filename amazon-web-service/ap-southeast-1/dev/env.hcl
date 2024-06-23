# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  account_name   = get_env("ACCOUNT_NAME")
  aws_account_id = get_env("ACCOUNT_ID")

  environment = "dev"
  azs = ["ap-southeast-1a"]
  vpc_cidr_block = "10.1.0.0/16"
  # cluster_cidr_block = "172.20.0.0/16"
  public_cidr = ["10.1.10.0/24", "10.1.11.0/24"]
  private_cidr = ["10.1.20.0/24", "10.1.21.0/24"]

  tags = {
    CreateBy = "Terraform"
  }

  kube_version = "1.27"
}
