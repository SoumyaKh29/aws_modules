output "arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = aws_kms_key.kms_key.arn
}

output "id" {
  description = "The ID of the KMS."
  value       = aws_kms_key.kms_key.id
}

output "key_id" {
  description = "The globally unique identifier for the key."
  value       = aws_kms_key.kms_key.key_id
}

output "kms_alias" {
  description = "The ID of the secret."
  value       = aws_kms_alias.kms_alias.name
}

# output "secret_id" {
#   description = "The ID of the secret."
#   value       = aws_kms_key.kms_key.arn
# }