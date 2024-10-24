# outputs.tf

output "bucket_ids" {
  description = "The names of the S3 buckets"
  value       = aws_s3_bucket.s3_bucket.id
}

output "bucket_arns" {
  description = "The ARNs of the S3 buckets"
  value       = aws_s3_bucket.s3_bucket.arn 
}

output "bucket_policy_id" {
  description = "The ID of the bucket policy"
  value       = aws_s3_bucket_policy.bucket_policy.id
}


