module "bucket" {
  source = "../modules/s3-bucket"

  bucket_name = var.bucket_name
  tags        = var.tags
}
