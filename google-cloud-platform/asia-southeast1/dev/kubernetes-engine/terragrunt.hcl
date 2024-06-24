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

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    network_name = "name"
    subnet_names = ["name1","name2"]
    subnets_secondary_ranges = [
      [
        {
          ip_cidr_range = "10.0.0.1/24"
          range_name = "name1"
        },
        {
          ip_cidr_range = "10.0.0.2/24"
          range_name = "name2"
        },
      ],
      [
        {
          ip_cidr_range = "10.0.0.3/24"
          range_name = "name1"
        },
        {
          ip_cidr_range = "10.0.0.4/24"
          range_name = "name2"
        },
      ]
    ]
  }
}

terraform {
  # source = "../../../../../demo-terraform-modules//google-cloud-platform/kubernetes-engine"
  source = "git::git@github.com:TheDao032/demo-terraform-modules.git//google-cloud-platform/kubernetes-engine?ref=${local.environment}"
}

inputs = {
  network_name      = dependency.vpc.outputs.network_name
  subnetwork_name   = dependency.vpc.outputs.subnet_names[0]
  secondary_subnets = tolist(dependency.vpc.outputs.subnets_secondary_ranges[0])
}
