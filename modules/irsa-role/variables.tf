variable "role_name" {
  type        = string
  description = "Name of the IAM role."
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the EKS cluster's IAM OIDC provider."
}

variable "oidc_provider_url" {
  type        = string
  description = "Issuer URL of the EKS cluster's IAM OIDC provider (with https://)."
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace of the service account this role is bound to."
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes service account this role is bound to."
}

variable "policy_arns" {
  type        = list(string)
  description = "IAM policy ARNs to attach to the role."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the role."
  default     = {}
}
