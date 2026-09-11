variable "name" {
  type        = string
  description = "Name to tag the VPC and its resources with."
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones to create one public subnet in each."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR block for each public subnet, one per availability zone."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources."
  default     = {}
}
