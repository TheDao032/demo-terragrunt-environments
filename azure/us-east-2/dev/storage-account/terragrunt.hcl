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
  source = "../../../../../terraform-modules//azure/storage-account"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/storage-account?ref=master"
}

inputs = {
  resource_group = dependency.rg.outputs.name
  subnets        = dependency.vnet.outputs.subnets
  private_endpoint_dns_mapping = {
    blob = dependency.vnet.outputs.storage_account_privatelink_dns_zone_id
  }
}
