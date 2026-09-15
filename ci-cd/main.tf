terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Bucket/key/region are supplied per-account via
  # `terraform init -backend-config=backend/<account>.hcl`
  backend "s3" {}
}