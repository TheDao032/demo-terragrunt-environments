locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

include {
  path = find_in_parent_folders()
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    oidc_provider_arn = "oidc_provider_arn"
    oidc_issuer_url = "https://oidc_issuer.com"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

terraform {
  # source = "../../../../../demo-terraform-modules//amazon-web-service/eks-resource"
  source = "git::git@github.com:TheDao032/demo-terraform-modules.git//amazon-web-service/eks-resource?ref=${local.environment}"
}

inputs = {
  buckets = {
    thanos = {
      ExpirationInDays = "90"
    }
  }

  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn
  oidc_issuer = dependency.eks.outputs.oidc_issuer_url
}
