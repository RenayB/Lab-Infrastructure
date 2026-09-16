region = "us-east-1"

instance_type = "t4g.nano"
role_name     = "renays-lab-dev-bastion-role"

eks_state_bucket = "renays-lab-dev-s3"
eks_state_key    = "renays-lab-dev-eks-tf-state/terraform.tfstate"
eks_state_region = "us-east-2"

tags = {
  project     = "renays-lab-dev-bastion"
  environment = "dev"
}
