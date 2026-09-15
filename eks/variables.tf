variable "region" {
  type        = string
  description = "AWS region to deploy the cluster in."
}

variable "vpc_name" {
  type        = string
  description = "Name to tag the VPC and its resources with."
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for the public subnets."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR block for each public subnet, one per availability zone."
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to reach the public EKS API server endpoint."
}

variable "cluster_role_name" {
  type        = string
  description = "Name of the IAM role for the EKS control plane."
  default     = "eks-cluster-role"
}

variable "node_role_name" {
  type        = string
  description = "Name of the IAM role for EKS worker nodes."
  default     = "eks-node-role"
}

variable "node_group_name" {
  type        = string
  description = "Name of the managed node group."
}

variable "node_instance_types" {
  type        = list(string)
  description = "EC2 instance types for the managed node group."
  default     = ["t3.small"]
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of worker nodes."
  default     = 0
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of worker nodes."
  default     = 0
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of worker nodes."
  default     = 1
}

variable "cert_manager_namespace" {
  type        = string
  description = "Kubernetes namespace cert-manager runs in."
  default     = "cert-manager"
}

variable "cert_manager_service_account" {
  type        = string
  description = "cert-manager Kubernetes service account name."
  default     = "cert-manager"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to created resources."
  default     = {}
}
