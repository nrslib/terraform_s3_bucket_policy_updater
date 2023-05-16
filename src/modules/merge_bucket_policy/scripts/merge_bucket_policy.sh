#!/usr/bin/env bash

bucket_id="${1}"
append_statements_escaped="${2}"

source_json=$(aws --region ap-northeast-1 s3api get-bucket-policy --bucket "${1}" --query Policy --output text)
merged_json=$(echo "$source_json" | jq ".Statement |= (. + ${append_statements_escaped} | unique_by(.Sid))")
merged_json_escaped=$(echo "$merged_json" | jq -c)

response=$(aws --region ap-northeast-1 s3api put-bucket-policy --bucket "${bucket_id}" --policy "${merged_json_escaped}")

jq -n \
  --arg data "${response}" \
  --arg append_statements_escaped "${append_statements_escaped}" \
  --arg bucket_id "${bucket_id}" \
  --arg merged_json "${merged_json}" \
  --arg merged_json_escaped "${merged_json_escaped}" \
  --arg source_json "${source_json}" \
  '{
    "data": $data,
    "append_statements_escaped" : $append_statements_escaped,
    "bucket_id" : $bucket_id,
    "merged_json" : $merged_json,
    "merged_json_escaped" : $merged_json_escaped,
    "source_json" : $source_json
  }'