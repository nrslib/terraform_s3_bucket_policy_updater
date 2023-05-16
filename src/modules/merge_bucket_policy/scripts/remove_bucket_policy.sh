#!/usr/bin/env bash

bucket_id="${1}"
append_statements_escaped="${2}"
sids=()
for item in $(echo "${append_statements_escaped}" | jq -c '.[]'); do
  sids+=("$(echo "${item}" | jq .Sid)")
done

csv_sids=$(IFS=","; echo "${sids[*]}")
current_policy=$(aws --region ap-northeast-1 s3api get-bucket-policy --bucket "${bucket_id}" --query Policy --output text)
jq_query_remove_target="del(.Statement[] | select([.Sid] | inside([$csv_sids])))"
removed_policy=$(echo "$current_policy" | jq "$jq_query_remove_target")

response=$(aws --region ap-northeast-1 s3api put-bucket-policy --bucket "${bucket_id}" --policy "${removed_policy}")

jq -n \
  --arg data "${response}" \
  --arg append_statements_escaped "${append_statements_escaped}" \
  --arg bucket_id "${bucket_id}" \
  --arg current_policy "${current_policy}" \
  --arg jq_query_remove_target "${jq_query_remove_target}" \
  --arg removed_policy "${removed_policy}" \
  --arg sids "${sids}" \
  --arg csv_sids "${csv_sids}" \
  '{
    "data": $data,
    "append_statements_escaped" : $append_statements_escaped,
    "bucket_id" : $bucket_id,
    "current_policy" : $current_policy,
    "jq_query_remove_target" : $jq_query_remove_target,
    "removed_policy" : $removed_policy,
    "sids" : $sids,
    "csv_sids" : $csv_sids
  }'