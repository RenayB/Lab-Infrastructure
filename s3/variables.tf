variable "region" {
  type        = string
  description = "AWS region to create the bucket in."
}

variable "bucket_name" {
  type        = string
  description = "Globally-unique S3 bucket name."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the bucket."
  default     = {}
}
