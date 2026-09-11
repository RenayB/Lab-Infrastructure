terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # No remote backend here on purpose: this stack creates the bucket other
  # stacks store their state in, so it has to bootstrap with local state
  # first. Point it at a new account by swapping the AWS credentials/profile
  # and passing a new tfvars file.
}

provider "aws" {
  region = var.region
}
