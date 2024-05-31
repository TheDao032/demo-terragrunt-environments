locals {}

include {
  path   = find_in_parent_folders()
}

dependency "rg" {
  config_path = "../resource-group"
}

dependency "vnet" {
  config_path = "../vnet"
}

dependency "storage-account" {
  config_path = "../storage-account"
}

terraform {
  source = "../../../../../inogen-terraform-modules//azure/aks"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/aks?ref=master"
}

inputs = {
  resource_group = dependency.rg.outputs.name
  vnet_name      = dependency.vnet.outputs.name
  node_subnet_id = dependency.vnet.outputs.subnets[1]
  gateway_subnet_id = dependency.vnet.outputs.gateway_subnet

  storage_account_name = dependency.storage-account.outputs.storage_account_name
}
