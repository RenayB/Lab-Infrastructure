module "repository" {
  source = "../modules/ecr-repo"

  repository_name = var.repository_name
  tags             = var.tags
}

# Preserves existing state: this repo used to be a bare resource in this
# root module before it moved into modules/ecr-repo.
moved {
  from = aws_ecr_repository.renays_lab_ecr
  to   = module.repository.aws_ecr_repository.this
}
