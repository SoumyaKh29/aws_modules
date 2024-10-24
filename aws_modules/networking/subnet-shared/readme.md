# AWS Subnet Terraform Module

This Terraform module provisions an AWS Subnet with optional sharing functionality using AWS Resource Access Manager (RAM). The module includes customizable tag options and allows you to conditionally share the created subnet with other AWS accounts or organizations.

## Features

- Creates an AWS Subnet with customizable tags.
- Optionally shares the subnet with other AWS accounts or organizations using AWS RAM.
- Allows external principals to access the shared subnet (if enabled).
- Flexible resource naming conventions using the environment, application name, and other variables.

## Resources

This module creates the following resources:
- `aws_subnet`: The subnet created in the specified VPC.
- `aws_ram_resource_share`: (Optional) A RAM resource share for sharing the subnet.
- `aws_ram_resource_association`: (Optional) Associates the created subnet with the resource share.
- `aws_ram_principal_association`: (Optional) Associates an AWS Account or Organization with the resource share.

## Usage

Here’s an example of how to use this module in your Terraform code:

```hcl
module "subnet" {
  source = "github.com/test.git//aws/networking/subnet-shared"

  vpc_id                   = "vpc-xxxxxx"
  subnet_cidrs             = "10.0.1.0/24"
  availability_zones       = "us-east-1a"
  map_public_ip_on_launch  = true
  sub_type                 = "public"

  # Optional parameters for sharing the subnet
  share_subnet             = true
  allow_external_principals = false
  principal_id             = "123456789012"  # AWS Account ID or Organization ARN

  # Tagging
  auid                     = "SE-1234"
  zone                     = "us-east-1a"
  region                   = "us-east-1"
  environment              = "prod"
  application_name         = "app-name"
  department               = "IT"
  business_owner_email     = "owner@example.com"
  dev_owner_email          = "dev@example.com"
  criticality              = "high"
  cost_center              = "CC-12345"
  maintenance_window       = "Sun:02:00-Sun:04:00"
  source_tool              = "terraform"
  additional_tags          = {
    CustomTag = "custom-value"
  }
}
```

## Input Variables

| Name                     | Type    | Default     | Description |
|--------------------------|---------|-------------|-------------|
| `vpc_id`                 | string  | n/a         | ID of the VPC where the subnet will be created. |
| `subnet_cidrs`           | string  | n/a         | CIDR block for the subnet. |
| `availability_zones`     | string  | n/a         | Availability zone for the subnet. |
| `map_public_ip_on_launch`| bool    | false       | Whether to map public IP on subnet launch. |
| `sub_type`               | string  | "public"    | The type of subnet (public or private). |
| `share_subnet`           | bool    | false       | Whether to share the subnet using AWS RAM. |
| `allow_external_principals`| bool  | false       | Whether to allow external principals to access the subnet. |
| `principal_id`           | string  | null        | AWS Account ID or Organization ARN to share the subnet with. |
| `zone`                   | string  | n/a         | The availability zone where the subnet is created. |
| `region`                 | string  | n/a         | AWS region for the subnet. |
| `environment`            | string  | "dev"       | The environment (e.g., dev, prod). |
| `application_name`       | string  | n/a         | The name of the application associated with this subnet. |
| `auid`                   | string  | n/a         | Application Unique Identifier (AUID). |
| `department`             | string  | n/a         | Department responsible for the subnet. |
| `business_owner_email`   | string  | n/a         | Business owner's email address. |
| `dev_owner_email`        | string  | n/a         | Developer owner's email address. |
| `criticality`            | string  | n/a         | Criticality of the subnet (e.g., high, medium, low). |
| `cost_center`            | string  | n/a         | Cost center for accounting. |
| `maintenance_window`     | string  | n/a         | Maintenance window for the subnet (e.g., Sun:02:00-Sun:04:00). |
| `source_tool`            | string  | "terraform" | Tool used to create the resource. |
| `additional_tags`        | map     | {}          | Additional tags to apply to the subnet and resources. |


## Outputs

| Name                           | Description |
|---------------------------------|-------------|
| `subnet_id`                    | The ID of the created subnet. |
| `subnet_arn`                   | The ARN of the created subnet. |
| `subnet_cidr_block`            | The CIDR block of the created subnet. |
| `subnet_availability_zone`     | The availability zone of the subnet. |
| `subnet_share_arn`             | (Optional) The ARN of the subnet resource share. |
| `subnet_shared_with_principal` | (Optional) The AWS Account ID or Organization ARN with which the subnet is shared. |
