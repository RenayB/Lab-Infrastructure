variable "region" {
  type        = string
  description = "AWS region to deploy the bastion in."
}

variable "eks_state_bucket" {
  type        = string
  description = "S3 bucket holding the eks stack's Terraform state."
}

variable "eks_state_key" {
  type        = string
  description = "S3 key of the eks stack's Terraform state file."
}

variable "eks_state_region" {
  type        = string
  description = "Region of the eks stack's state bucket."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the bastion. Only runs SSM agent and forwards traffic, so a burstable nano/micro is enough."
  default     = "t4g.nano"
}

variable "role_name" {
  type        = string
  description = "Name for the bastion's IAM role and instance profile."
  default     = "bastion-role"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to created resources."
  default     = {}
}
