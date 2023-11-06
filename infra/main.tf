terraform {
  required_version = "1.6.3"
}
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}