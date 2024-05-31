locals {
  environment = "dev"

  kubernetes_version = "1.27.7"

  additional_tags = {
    "Environment" = "dev"
  }

  secrets = {
    jenkinsUsername      = "admin"
    jenkinsPassword      = "{ _RANDOM_ = 18 }"
    jenkinsSlaveUsername = "jenkins"
    jenkinsSlavePassword = "{ _RANDOM_ = 18 }"
  }
}
