data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "main_bucket" {

    bucket = "${data.aws_caller_identity.current.account_id}-${var.bucket_name}"
    force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "main_bucket_acl" {
  bucket =  aws_s3_bucket.main_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id
  versioning_configuration {
    status = var.has_versioning ? "Enabled" : "Suspended"
    mfa_delete = "Disabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "main_bucket_lifecycle" {
  

  bucket = aws_s3_bucket.main_bucket.bucket
  rule {
       id = "lifecycle rule"
      expiration {
          days = var.expiration_days
      }
     transition {
      days          = var.transition_days
      storage_class = "STANDARD_IA"
    }
     status = "Enabled"
  }
  
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning_main_bucket_lifecycle" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.main_bucket_versioning]

  bucket = aws_s3_bucket.main_bucket.bucket

  rule {
    id = "versions lifecylce rule"


    noncurrent_version_expiration {
      noncurrent_days = var.expiration_days
    }

    noncurrent_version_transition {
      noncurrent_days = var.transition_days
      storage_class   = "STANDARD_IA"
    }

    status = var.has_versioning ? "Enabled" : "Disabled"
  }
}

