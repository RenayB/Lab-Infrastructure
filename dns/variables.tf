variable "region" {
  type        = string
  description = "AWS region to create the hosted zone in. Route53 is a global service, so this mainly affects where the API calls are made from."
}

variable "domain_name" {
  type        = string
  description = "Subdomain this zone is authoritative for, e.g. dev.renays-lab.com. The apex domain (renays-lab.com) and its registration stay in the root account - this zone only needs an NS delegation record added there, not ownership of the whole domain."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to created resources."
  default     = {}
}
