locals {}

include {
  path = find_in_parent_folders()
}

dependency "rg" {
  config_path = "../resource-group"
}

terraform {
  source = "../../../../../terraform-modules//azure/keyvault"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/keyvault?ref=master"
}

inputs = {
  resource_group_name = dependency.rg.outputs.name
  location            = dependency.rg.outputs.location
}
