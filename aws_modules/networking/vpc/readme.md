# Module: VPC

This Terraform module creates an Amazon Web Services (AWS) Virtual Private Cloud (VPC) designed for production environments. The module provides the flexibility to configure public and private subnets, NAT gateways, route tables, and various VPC options, with the following key features:

## Features

- **VPC** creation with a customizable CIDR block.
- **Public subnets** can be optionally created with the ability to map public IPs on launch.
- **Private subnets** with optional route tables.
- **NAT gateways** can be created for selected public subnets.
- **Flexible route tables** for both public and private subnets, with customizable associations.

## Usage

### Basic Example

```hcl
module "vpc" {
  source = "github.com/test.git//aws/networking/vpc"

  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Public Subnets
  create_public_subnets   = true
  public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  map_public_ip_on_launch = {
    0 = true,
    1 = false,
    2 = true
  }

  # Private Subnets
  private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]

  # NAT Gateways
  create_nat_gateway        = true
  nat_gateway_subnet_indexes = [0, 2]

  # Route Tables for Public Subnets
  create_route_tables                     = true
  public_route_table_names                = ["public-1", "public-2"]
  public_subnet_route_table_indexes       = [0, 1]
  public_route_table_indexes_for_association = [0, 0]

  # Route Tables for Private Subnets
  private_route_table_names               = ["private-1", "private-2"]
  private_subnet_route_table_indexes      = [0, 1]
  private_route_table_indexes_for_association = [0, 1]

  # Routes for Route Tables
  public_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = aws_internet_gateway.this.id
    }
  ]

  private_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = aws_nat_gateway.this[0].id
    }
  ]
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|---------|
| `optional_num`        | Optional number appended to resource naming                 | `string`    | `null`  | No       |
| `purpose`             | Purpose of the storage account (e.g., boot, diag, gen)       | `string`    | N/A     | Yes      |
| `zone`                | Azure Zone example (e.g., NAZ or SAZ)                       | `string`    | N/A     | Yes      |
| `auid`                | Azure Unique App ID. Replace with unique identifier if none | `string`    | N/A     | Yes      |
| `project_name`        | Name of the product for naming resources (e.g., OnePortal)  | `string`    | N/A     | Yes      |
| `application_name`    | Name of the application for tags (e.g., OnePortalAPI)       | `string`    | N/A     | Yes      |
| `department`          | Department for tags                                          | `string`    | N/A     | Yes      |
| `business_owner_email`| Business owner email for tags                               | `string`    | N/A     | Yes      |
| `dev_owner_email`     | Dev owner email for tags                                    | `string`    | N/A     | Yes      |
| `criticality`         | Criticality of the project (e.g., LOW or HIGH)              | `string`    | N/A     | Yes      |
| `cost_center`         | Cost center ID for tags                                     | `string`    | N/A     | Yes      |
| `maintenance_window`  | Maintenance window for the project                          | `string`    | N/A     | Yes      |
| `additional_tags`     | Additional tagging                                          | `map(string)`| `null`  | No       |
| `environment`         | Environment for tags (e.g., DEV, QA, PROD)                  | `string`    | N/A     | Yes      |
| `source_tool`         | IAC tool used to deploy the resource (Terraform or Terragrunt) | `string`    | `terraform` | No   |
| `vpc_cidr` | CIDR block for the VPC  | `string` | `10.0.0.0/16` |
| `availability_zones`| List of availability zones for subnets | `list(string)` | `[]` |
| `create_public_subnets` | Whether to create public subnets  | `bool`  | `false`    |
| `public_subnet_cidrs`| List of CIDR blocks for public subnets  | `list(string)`  | `[]` |
| `map_public_ip_on_launch` | Map public IP on launch for public subnets   | `map(bool)`     | `{}` |
| `create_nat_gateway` | Whether to create NAT gateways    | `bool`  | `false`    |
| `nat_gateway_subnet_indexes` | Indexes of public subnets for NAT gateways   | `list(number)`  | `[]` |
| `private_subnet_cidrs` | List of CIDR blocks for private subnets | `list(string)`  | `[]` |
| `create_route_tables`| Whether to create route tables | `bool` | `false` |
| `public_route_table_names` | Names of the public route tables to create | `list(string)`| `[]`|
| `public_subnet_route_table_indexes` | Indexes of public subnets for route table associations | `list(number)`  | `[]` |
| `public_route_table_indexes_for_association` | Route table indexes for public subnet associations | `list(number)`| `[]` |
| `private_route_table_names` | Names of the private route tables to create | `list(string)` | `[]`|
| `private_subnet_route_table_indexes` | Indexes of private subnets for route table associations | `list(number)`  | `[]` |
| `private_route_table_indexes_for_association` | Route table indexes for private subnet associations | `list(number)`  | `[]` |
| `public_routes` | List of routes for public route tables | `list(object({ destination_cidr_block = string, gateway_id = string, nat_gateway_id = string }))` | `[]` |
| `private_routes` | List of routes for private route tables  | `list(object({ destination_cidr_block = string, gateway_id = string, nat_gateway_id = string }))` | `[]` |

## Outputs
| Name                   | Description                                      |
|------------------------|--------------------------------------------------|
| `vpc_id`               | The ID of the created VPC                       |
| `public_subnet_ids`    | List of IDs of the created public subnets       |
| `private_subnet_ids`   | List of IDs of the created private subnets      |
| `nat_gateway_ids`      | List of IDs of the created NAT gateways         |
| `public_route_table_ids` | List of IDs of the created public route tables |
| `private_route_table_ids` | List of IDs of the created private route tables |

## Conditional Resources

This module includes conditional logic to create resources only when specific conditions are met. Below is a description of how conditional resources are handled:

### Public Subnets

The creation of public subnets is controlled by the `create_public_subnets` variable. If set to `true`, public subnets will be created using the CIDR blocks specified in `public_subnet_cidrs`. The `map_public_ip_on_launch` variable allows you to configure whether to map public IP addresses on launch for each public subnet.

### NAT Gateways

NAT gateways are created based on the `create_nat_gateway` variable. If `true`, NAT gateways are set up in the public subnets specified by `nat_gateway_subnet_indexes`. Each NAT gateway is associated with an Elastic IP address.

### Route Tables

Route tables are created based on the `create_route_tables` variable. If `true`, route tables are created for both public and private subnets. Public route tables are associated with public subnets, and private route tables are associated with private subnets.

- **Public Route Tables**: These route tables are associated with public subnets and include routes as specified in `public_routes`.
- **Private Route Tables**: These route tables are associated with private subnets and include routes as specified in `private_routes`.

This conditional approach ensures that resources are only created and associated based on your specific requirements and configuration.

## Example Configurations

### VPC with Public and Private Subnets
This example demonstrates how to configure a VPC with both public and private subnets. Public subnets will be created with the option to map public IP addresses on launch, and NAT gateways will be used to provide internet access to private subnets.

```hcl
module "vpc" {
  source = "github.com/test.git//aws/networking/vpc"

  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Public Subnets
  create_public_subnets   = true
  public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  map_public_ip_on_launch = {
    0 = true,
    1 = false,
    2 = true
  }

  # Private Subnets
  private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]

  # NAT Gateways
  create_nat_gateway        = true
  nat_gateway_subnet_indexes = [0, 2]

  # Route Tables for Public Subnets
  create_route_tables                     = true
  public_route_table_names                = ["public-1", "public-2"]
  public_subnet_route_table_indexes       = [0, 1]
  public_route_table_indexes_for_association = [0, 0]

  # Route Tables for Private Subnets
  private_route_table_names               = ["private-1", "private-2"]
  private_subnet_route_table_indexes      = [0, 1]
  private_route_table_indexes_for_association = [0, 1]

  # Routes for Route Tables
  public_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = aws_internet_gateway.this.id
    }
  ]

  private_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = aws_nat_gateway.this[0].id
    }
  ]
}
```

### VPC with Private Subnets Only
This example demonstrates how to configure a VPC with only private subnets, without creating any public subnets or NAT gateways.

```hcl
module "vpc" {
  source = "github.com/test.git//aws/networking/vpc"

  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Public Subnets
  create_public_subnets   = false

  # Private Subnets
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

  # NAT Gateways
  create_nat_gateway = false

  # Route Tables for Private Subnets
  create_route_tables                     = true
  private_route_table_names               = ["private-1"]
  private_subnet_route_table_indexes      = [0]
  private_route_table_indexes_for_association = [0]

  # Routes for Route Tables
  private_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = aws_vpc.this.id
    }
  ]
}
```