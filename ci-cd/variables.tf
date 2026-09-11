variable "github_repos" {
  type        = list(string)
  description = "GitHub repositories."
}

variable "ecr_repos" {
  type        = list(string)
  description = "Private ECR repository names this role can push to"
}