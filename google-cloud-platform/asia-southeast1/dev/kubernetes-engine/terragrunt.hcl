locals {}

include {
  path = find_in_parent_folders()
}

dependency "service" {
  config_path = "../service"
}

dependency "vpc" {
  config_path = "../vpc"
}

terraform {
  source = "../../../../../demo-terraform-modules//google-cloud-platform/kubernetes-engine"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/vnet?ref=master"
}

inputs = {
  network_name      = dependency.vpc.outputs.network_name
  subnetwork_name   = dependency.vpc.outputs.subnet_names[0]
  secondary_subnets = dependency.vpc.outputs.subnets_secondary_ranges[0]
}
