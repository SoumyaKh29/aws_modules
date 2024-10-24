output "subnet_id" {
  value       = aws_subnet.subnet.id
  description = "The ID of the created subnet"
}

output "subnet_arn" {
  value       = aws_subnet.subnet.arn
  description = "The ARN of the created subnet"
}

output "subnet_cidr_block" {
  value       = aws_subnet.subnet.cidr_block
  description = "The CIDR block of the subnet"
}

output "subnet_availability_zone" {
  value       = aws_subnet.subnet.availability_zone
  description = "The availability zone of the subnet"
}

# Outputs for subnet sharing (conditional on sharing)
output "subnet_share_arn" {
  value       = var.share_subnet ? "${aws_ram_resource_share.subnet_share[0].arn}" : ""
  description = "The ARN of the resource share for the subnet"
}

output "subnet_shared_with_principal" {
  value       = var.share_subnet ? "${aws_ram_principal_association.principal_association[0].principal}" : ""
  description = "The AWS Account ID or Organization ARN with which the subnet is shared"
}
