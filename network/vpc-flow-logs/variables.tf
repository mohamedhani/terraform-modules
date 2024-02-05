
module "vpc_flow_log_bucket" {
  source            = "../../s3-bucket/"
  bucket_name       = "${var.vpc_name}-flow-logs"
  force_destroy     = true
  enable_versioning = false
}

resource "aws_flow_log" "main_vpc_log_flow" {
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = module.vpc_flow_log_bucket.bucket_arn
  vpc_id               = var.vpc_id
  # use default format of AWS
  max_aggregation_interval = 60
  destination_options {
    file_format        = "parquet"
    per_hour_partition = true
  }
}