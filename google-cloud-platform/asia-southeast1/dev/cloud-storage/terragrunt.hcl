locals {}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../demo-terraform-modules//google-cloud-platform/cloud-storage"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/vnet?ref=master"
}

inputs = {}
