output "iam_role_name" {
  description = "The name of the IAM role created."
  value       = aws_iam_role.role.name
}

output "iam_role_arn" {
  description = "The ARN of the IAM role created."
  value       = aws_iam_role.role.arn
}

output "role_assume_policy" {
  description = "The assume role policy document for the IAM role."
  value       = data.aws_iam_policy_document.assume_role_policy.json
}

output "role_tags" {
  description = "The tags applied to the IAM role."
  value       = aws_iam_role.role.tags
}
