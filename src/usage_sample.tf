module "bucket_policy" {
  source = "./modules/merge_bucket_policy"

  bucket_name                     = var.bucket_name
  append_bucket_policy_statements = [
    jsonencode({
      "Sid" : local.sid_full_timestamped
      "Effect" : "Allow"
      "Principal" : {
        "AWS" : [
          "arn:aws:iam::${var.aws_account_id}:root"
        ]
      }
      "Action" : [
        "s3:GetLifecycleConfiguration",
        "s3:ListBucket"
      ]
      "Resource" : "arn:aws:s3:::${var.bucket_name}"
    }),
    jsonencode({
      "Sid" : "${local.sid_full_timestamped}-2"
      "Effect" : "Allow"
      "Principal" : {
        "AWS" : [
          "arn:aws:iam::${var.aws_account_id}:root"
        ]
      }
      "Action" : "s3:GetObject"
      "Resource" : "arn:aws:s3:::${var.bucket_name}/*"
    })
  ]
}