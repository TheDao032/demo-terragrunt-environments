locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

include {
  path   = find_in_parent_folders()
}

terraform {
  # source = "../../../../../inogen-terraform-modules//azure/resource-group"
  source = "git::git@github.com:TheDao032/demo-terraform-modules.git//azure/resource-group?ref=${local.environment}"
}

inputs = {
}
