locals {}

include {
  path   = find_in_parent_folders()
}

terraform {
  source = "../../../../../inogen-terraform-modules//azure/resource-group"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/resource-group?ref=master"
}

inputs = {
}
