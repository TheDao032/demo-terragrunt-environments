locals {
  project = get_env("PROJECT", "infrastructure")
  project_id = get_env("PROJECT_ID", "infrastructure-424404")
  bucket = get_env("BUCKET", "terragruntbackend")
}
