output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = var.create_internet_gateway ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = var.create_nat_gateway ? aws_nat_gateway.nat[0].id : null
}

output "nat_gateway_private_ip" {
  description = "The private IP address of the NAT Gateway."
  value       = var.create_nat_gateway ? aws_nat_gateway.nat[0].private_ip : null
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway."
  value       = var.create_nat_gateway && var.connectivity_type == "public" ? aws_nat_gateway.nat[0].public_ip : null
}

output "resource_name" {
  description = "The name of the resources created."
  value       = local.name
}

output "tags" {
  description = "The tags applied to the resources."
  value       = local.tagging
}
