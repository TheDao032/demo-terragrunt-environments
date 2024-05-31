### Execution
- `cd` to each environment region (e.g: `dev/us-east-2/dev`).
- Run `rm -rf **/.terragrunt-cache* && rm -rf **/.terraform.lock.hcl` to remove existing caches.
- Run `terragrunt run-all init` to initialize all environment modules.
- Run `terragrunt run-all apply` to apply changes to infrastructure.
