data "aws_s3_bucket" "target" {
  bucket = var.bucket_name
}