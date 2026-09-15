variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
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

variable "vpc_id" {
  type        = string
  description = "VPC ID the cluster and node group run in, used to scope the node security group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the cluster control plane and node group."
}

variable "endpoint_public_access" {
  type        = bool
  description = "Whether the cluster API server endpoint is publicly accessible."
  default     = true
}

variable "endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to reach the public API server endpoint. Required whenever endpoint_public_access is true - AWS defaults to 0.0.0.0/0 if this isn't set."
}

variable "endpoint_private_access" {
  type        = bool
  description = "Whether the cluster API server endpoint is privately accessible from the VPC."
  default     = false
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

variable "tags" {
  type        = map(string)
  description = "Tags to apply to cluster resources."
  default     = {}
}
