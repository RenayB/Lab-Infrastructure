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

provider "aws" {
  region = var.region
}

# Reads the eks stack's VPC/subnet so this stays in the same network without
# duplicating IDs by hand - the two stacks are separate state files but the
# bastion only exists to reach that VPC.
data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = var.eks_state_bucket
    key    = var.eks_state_key
    region = var.eks_state_region
  }
}
