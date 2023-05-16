resource "null_resource" "apply_policy" {
  triggers = {
    append_bucket_policy_statements = "[${join(",", var.append_bucket_policy_statements)}]"
    bucket_id                      = data.aws_s3_bucket.target.id
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/merge_bucket_policy.sh ${self.triggers.bucket_id} '${self.triggers.append_bucket_policy_statements}'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/remove_bucket_policy.sh ${self.triggers.bucket_id} '${self.triggers.append_bucket_policy_statements}'"
  }
}
