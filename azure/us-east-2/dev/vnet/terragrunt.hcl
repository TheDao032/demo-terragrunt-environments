locals {}

include {
  path   = find_in_parent_folders()
}

dependency "rg" {
  config_path = "../resource-group"
}

terraform {
  source = "../../../../../terraform-modules//azure/vnet"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/vnet?ref=master"
}

inputs = {
  resource_group = dependency.rg.outputs.name
}