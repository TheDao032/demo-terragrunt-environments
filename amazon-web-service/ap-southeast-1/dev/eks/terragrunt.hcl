locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    id = "id"
    # subnet_names = ["name1","name2"]
    # subnets_secondary_ranges = [
    #   [
    #     {
    #       ip_cidr_range = "10.0.0.1/24"
    #       range_name = "name1"
    #     },
    #     {
    #       ip_cidr_range = "10.0.0.2/24"
    #       range_name = "name2"
    #     },
    #   ],
    #   [
    #     {
    #       ip_cidr_range = "10.0.0.3/24"
    #       range_name = "name1"
    #     },
    #     {
    #       ip_cidr_range = "10.0.0.4/24"
    #       range_name = "name2"
    #     },
    #   ]
    # ]
  }
}

terraform {
  # source = "../../../../../demo-terraform-modules//amazon-web-service/eks"
  source = "git::git@github.com:TheDao032/demo-terraform-modules.git//amazon-web-service/eks?ref=${local.environment}"
}

inputs = {
  vpc_id = dependency.vpc.outputs.id
}
