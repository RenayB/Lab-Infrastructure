variable "repository_name" {
  type        = string
  description = "Name of the ECR repository."
}

variable "image_tag_mutability" {
  type        = string
  description = "Whether image tags can be overwritten: MUTABLE or IMMUTABLE."
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be \"MUTABLE\" or \"IMMUTABLE\"."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "Scan images for vulnerabilities on push."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the repository."
  default     = {}
}
