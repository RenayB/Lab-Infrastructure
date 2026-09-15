terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "renays-lab-s3"
    key    = "renays-lab-ci-cd-tf-state/terraform.tfstate"
    region = "us-east-2"
  }
}

data "aws_caller_identity" "current" {}