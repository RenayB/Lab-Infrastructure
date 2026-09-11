variable "bucket_name" {
  type        = string
  description = "Globally-unique S3 bucket name."
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable object versioning on the bucket."
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Allow the bucket to be destroyed even if it still contains objects."
  default     = false
}

variable "block_public_access" {
  type        = bool
  description = "Block all public access to the bucket."
  default     = true
}

variable "enforce_tls" {
  type        = bool
  description = "Deny any request to the bucket that is not made over HTTPS."
  default     = true
}

variable "sse_algorithm" {
  type        = string
  description = "Server-side encryption algorithm: AES256 or aws:kms."
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm must be \"AES256\" or \"aws:kms\"."
  }
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ARN to use when sse_algorithm is \"aws:kms\". Defaults to the AWS-managed key."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the bucket."
  default     = {}
}
