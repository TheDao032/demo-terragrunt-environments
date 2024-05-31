locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

include {
  path = find_in_parent_folders()
}

dependency "service" {
  config_path = "../service"
}

terraform {
  # source = "../../../../../demo-terraform-modules//google-cloud-platform/vpc"
  source = "git@github.com:TheDao032/demo-terraform-modules.git//azure/vpc?ref=${local.environment}"
}

inputs = {}
