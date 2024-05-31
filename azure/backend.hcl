locals {
  subscription_id      = get_env("SUBSCRIPTION_ID")
  storage_account_name = get_env("STORAGE_ACCOUNT")
  resource_group_name  = get_env("RESOURCE_GROUP")
  container_name       = get_env("CONTAINER")
  tenant_id            = get_env("TENANT_ID")
  client_id            = get_env("CLIENT_ID")
  client_secret        = get_env("CLIENT_SECRET")
}
