data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "main_bucket" {

  bucket        = "${data.aws_caller_identity.current.account_id}-${var.bucket_name}"
  force_destroy = var.force_destroy
  tags = merge(
    { "Name" = "${data.aws_caller_identity.current.account_id}-${var.bucket_name}" }
  , var.default_tags)
}

resource "aws_s3_bucket_acl" "main_bucket_acl" {
  bucket = aws_s3_bucket.main_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status     = var.enable_versioning ? "Enabled" : "Suspended"
    mfa_delete = "Disabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "main_bucket_lifecycle_policy" {


  bucket = aws_s3_bucket.main_bucket.bucket
  rule {
    id = "s3 lifecycle policy"
    expiration {
      days = var.expiration_days
    }
    noncurrent_version_expiration {
      noncurrent_days = var.expiration_days
    }
    transition {
      days          = var.transition_days
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.transition_days
      storage_class   = "STANDARD_IA"
    }
    status = "Enabled"
  }
}

