locals {
}

include {
  path = find_in_parent_folders()
}

dependency "aks" {
  config_path = "../aks"
}

dependency "kv" {
  config_path = "../keyvault"
}

dependency "rg" {
  config_path = "../resource-group"
}

dependency "storage-account" {
  config_path = "../storage-account"
}

# Generate Azure providers-local
generate "provider-local" {
  path      = "provider-kube.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "kubernetes" {
      host = "${dependency.aks.outputs.admin_host}"
      client_key             = base64decode("${dependency.aks.outputs.admin_client_key}")
      client_certificate     = base64decode("${dependency.aks.outputs.admin_client_certificate}")
      cluster_ca_certificate = base64decode("${dependency.aks.outputs.admin_cluster_ca_certificate}")
    }

    provider "helm" {
      kubernetes {
        host = "${dependency.aks.outputs.admin_host}"
        client_key             = base64decode("${dependency.aks.outputs.admin_client_key}")
        client_certificate     = base64decode("${dependency.aks.outputs.admin_client_certificate}")
        cluster_ca_certificate = base64decode("${dependency.aks.outputs.admin_cluster_ca_certificate}")
      }
    }

    provider "kubectl" {
      host                   = "${dependency.aks.outputs.admin_host}"
      cluster_ca_certificate = base64decode("${dependency.aks.outputs.admin_cluster_ca_certificate}")
      token                  = "${dependency.aks.outputs.admin_password}"
      load_config_file       = false
    }
EOF
}

terraform {
  source = "../../../../../inogen-terraform-modules//azure/jenkins"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/jenkins?ref=master"
}

inputs = {
  parameters = {
    jenkins_url      = "http://20.247.146.44/"
    jenkins_username = dependency.kv.outputs.secrets["jenkinsUsername"]
    jenkins_password = dependency.kv.outputs.secrets["jenkinsPassword"]
  }

  storage_account_name = dependency.storage-account.outputs.storage_account_name
  resource_group       = dependency.rg.outputs.name
  node_resource_group  = dependency.aks.outputs.node_resource_group

  jenkins_plugins = {
    kubernetes              = "4203.v1dd44f5b_1cf9"
    workflow-aggregator     = "596.v8c21c963d92d"
    git                     = "5.2.1"
    configuration-as-code   = "1775.v810dc950b_514"
    parameterized-scheduler = "262.v00f3d90585cc"
    thinBackup              = "1.19"
    github-checks           = "554.vb_ee03a_000f65"
  }
}
