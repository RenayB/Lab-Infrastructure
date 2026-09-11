variable "region" {
  type        = string
  description = "AWS region to create the repository in."
}

variable "repository_name" {
  type        = string
  description = "Name of the ECR repository."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the repository."
  default     = {}
}
