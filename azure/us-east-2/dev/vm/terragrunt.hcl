locals {}

include {
  path = find_in_parent_folders()
}

dependency "rg" {
  config_path = "../resource-group"
}

dependency "vnet" {
  config_path = "../vnet"
}

terraform {
  source = "../../../../../terraform-modules//azure/vm"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/storage-account?ref=master"
}

inputs = {
  resource_group = dependency.rg.outputs.name
  subnets        = dependency.vnet.outputs.subnets
}
