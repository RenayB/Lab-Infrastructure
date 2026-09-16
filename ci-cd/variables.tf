variable "github_repos" {
  type        = list(string)
  description = <<-EOT
    GitHub repositories allowed to assume this role, in "OWNER@OWNER-ID/REPO@REPO-ID"
    form. Repos created after 2026-07-15 default to GitHub's immutable OIDC subject
    format (repo:OWNER@OWNER-ID/REPO@REPO-ID:...), so the plain "OWNER/REPO" form
    won't match the token's sub claim - look up the numeric IDs via
    `curl https://api.github.com/repos/OWNER/REPO` (.id and .owner.id).
  EOT
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to created resources."
  default     = {}
}