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

dependency "kv" {
  config_path = "../keyvault"
}

dependency "storage-account" {
  config_path = "../storage-account"
}

terraform {
  source = "../../../../../terraform-modules//azure/jenkins-slave"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/jenkins-slave?ref=master"
}

inputs = {
  username                = dependency.kv.outputs.secrets["jenkinsSlaveUsername"]
  password                = dependency.kv.outputs.secrets["jenkinsSlavePassword"]
  jenkins_master_username = dependency.kv.outputs.secrets["jenkinsUsername"]
  jenkins_master_password = dependency.kv.outputs.secrets["jenkinsPassword"]
  jenkins_url             = "http://20.22.39.177"
  subnet_id               = dependency.vnet.outputs.subnets[0]

  storage_account_name = dependency.storage-account.outputs.storage_account_name
  container_name       = dependency.storage-account.outputs.container_name
  resource_group       = dependency.rg.outputs.name
}
