locals {
  timestamp            = timestamp()
  timestamp_formatted  = formatdate("YYYYMMDDhhmmss", local.timestamp)
  sid_full_timestamped = "${var.terraform_id}-${var.bucket_name}-${local.timestamp_formatted}"
}

variable "terraform_id" { description = "your_unique_id" }
variable "bucket_name" { description = "your_bucket_name" }
variable "aws_account_id" { description = "your_aws_account_id" }

