output "instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = { for k, instance in aws_instance.this : k => instance.id }
}

output "public_ips" {
  description = "The public IP addresses of the EC2 instances"
  value       = { for k, instance in aws_instance.this : k => instance.public_ip }
}

output "private_ips" {
  description = "The private IP addresses of the EC2 instances"
  value       = { for k, instance in aws_instance.this : k => instance.private_ip }
}