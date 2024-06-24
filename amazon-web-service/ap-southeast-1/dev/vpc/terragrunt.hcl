locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

include {
  path = find_in_parent_folders()
}

terraform {
  # source = "../../../../../demo-terraform-modules//amazon-web-service/vpc"
  source = "git::git@github.com:TheDao032/demo-terraform-modules.git//amazon-web-service/vpc?ref=${local.environment}"
}

inputs = {}
