locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    id = "id"
    public_subnets = ["name1","name2"]
    private_subnets = ["name1","name2"]
    eks_securitygroup = "eks_security_group"
    eks_node_securitygroup = "eks_node_security_group"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

terraform {
  # source = "../../../../../demo-terraform-modules//amazon-web-service/eks"
  source = "git::git@github.com:TheDao032/demo-terraform-modules.git//amazon-web-service/eks?ref=${local.environment}"
}

inputs = {
  vpc_id = dependency.vpc.outputs.id
  subnets = dependency.vpc.outputs.public_subnets
  node_subnets = dependency.vpc.outputs.private_subnets
  security_groups = dependency.vpc.outputs.eks_securitygroup
  node_security_groups = dependency.vpc.outputs.eks_node_securitygroup
}
