# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load project variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  project      = local.project_vars.locals.project

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
        google = {
          source  = "hashicorp/google"
          version = "~> 5.30.0"
        }
        google-beta = {
          source  = "hashicorp/google-beta"
          version = "~> 5.30.0"
        }
      }
    }
EOF
}

generate "providers" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "google" {
      project = "${local.project}"
      region  = "${local.region}"
    }

    provider "google-beta" {
      project = "${local.project}"
      region  = "${local.region}"
    }
EOF
}

remote_state {
  backend = "gcs"
  config = {
    project  = "infrastructure"
    location = "asia-southeast1"
    bucket   = "terragruntbackend"
    prefix   = "${path_relative_to_include()}/terraform.tfstate"

    gcs_bucket_labels = {
      owner = "terragrunt"
      name  = "terraform_state_storage"
    }
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
  local.project_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
