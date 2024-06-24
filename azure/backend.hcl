locals {
  subscription_id      = get_env("ARM_SUBSCRIPTION_ID")
  storage_account_name = get_env("STORAGE_ACCOUNT")
  resource_group_name  = get_env("RESOURCE_GROUP")
  container_name       = get_env("CONTAINER")
  tenant_id            = get_env("ARM_TENANT_ID")
  client_id            = get_env("ARM_CLIENT_ID")
  client_secret        = get_env("ARM_CLIENT_SECRET")
}
