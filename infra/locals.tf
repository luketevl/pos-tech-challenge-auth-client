locals {
  lambdas_path = "${path.module}/../src/lambdas"

  common_tags = {
    Project   = "Auth Lambda with Terraform"
    CreatedAt = formatdate("YYYY-MM-DD", timestamp())
    ManagedBy = "Terraform"
    Owner     = "luketevl"
  }
}