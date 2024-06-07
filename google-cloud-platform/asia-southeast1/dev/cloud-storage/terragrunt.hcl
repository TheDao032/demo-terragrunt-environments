locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

include {
  path = find_in_parent_folders()
}

terraform {
  # source = "../../../../../demo-terraform-modules//google-cloud-platform/cloud-storage"
  source = "git@github.com:TheDao032/demo-terraform-modules//google-cloud-platform/cloud-storage?ref=${local.environment}"
}

inputs = {}
