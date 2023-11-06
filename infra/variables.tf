variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "aws_account_id" {
  type      = string
  sensitive = true
}

variable "aws_cognito_client_id" {
  type      = string
  sensitive = true
}

variable "aws_cognito_client_secret" {
  type      = string
  sensitive = true
}

variable "aws_cognito_user_pool" {
  type      = string
  sensitive = true
}