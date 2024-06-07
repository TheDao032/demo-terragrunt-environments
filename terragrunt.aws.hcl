# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Backend global vars
  backend_vars                 = read_terragrunt_config(find_in_parent_folders("backend.hcl"))
  backend_subscription_id      = local.backend_vars.locals.subscription_id
  backend_resource_group_name  = local.backend_vars.locals.resource_group_name
  backend_storage_account_name = local.backend_vars.locals.storage_account_name
  backend_container_name       = local.backend_vars.locals.container_name
  backend_tenant_id            = local.backend_vars.locals.tenant_id
  backend_client_id            = local.backend_vars.locals.client_id
  backend_client_secret        = local.backend_vars.locals.client_secret

  # Automatically load subscription variables
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))
  subscription_id   = local.subscription_vars.locals.subscription_id

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region      = local.region_vars.locals.region

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

# Generate Azure providers
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        azurerm = {
          source = "hashicorp/azurerm"
          version = "3.73.0"
        }
        azuread = {
          source = "hashicorp/azuread"
          version = "2.42.0"
        }
        helm = {
          source  = "hashicorp/helm"
          version = "2.12.0"
        }
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = "2.25.0"
        }
        kubectl = {
          source  = "gavinbunney/kubectl"
          version = ">= 1.7.0"
        }
      }
    }
EOF
}

generate "providers" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    provider "azurerm" {
      features {}
      subscription_id = "${local.subscription_id}"
    }

    provider "azuread" {
    }
EOF
}

remote_state {
  backend = "azurerm"
  config = {
    subscription_id      = "${local.backend_subscription_id}"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    resource_group_name  = "${local.backend_resource_group_name}"
    storage_account_name = "${local.backend_storage_account_name}"
    container_name       = "${local.backend_container_name}"
    tenant_id            = "${local.backend_tenant_id}"
    client_id            = "${local.backend_client_id}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.subscription_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
  { client_secret = "${local.backend_client_secret}" }
)
