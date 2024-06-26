locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

include {
  path = find_in_parent_folders()
}

dependency "project-service" {
  config_path = "../project-service"
  skip_outputs = true
}

terraform {
  # source = "../../../../../demo-terraform-modules//google-cloud-platform/vpc"
  source = "git::git@github.com:TheDao032/demo-terraform-modules.git//google-cloud-platform/vpc?ref=${local.environment}"
}

inputs = {}
