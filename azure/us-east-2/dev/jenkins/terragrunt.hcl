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
  source = "../../../../../terraform-modules//azure/jenkins"
  #source = "git@github.com:Inogen-Digital-Health/terraform-modules.git//azure/jenkins?ref=master"
}

inputs = {
  parameters = {
    jenkins_url      = "http://20.22.39.177/"
    jenkins_username = dependency.kv.outputs.secrets["jenkinsUsername"]
    jenkins_password = dependency.kv.outputs.secrets["jenkinsPassword"]
  }
}
