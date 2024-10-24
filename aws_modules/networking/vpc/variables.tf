variable "optional_num" {
  description = "Optional number appended to resource naming"
  type        = string
  default     = null
}

variable "purpose" {
  type        = string
  description = "Purpose of the storage account. Examples are: boot, diag, gen. For more info, check below."
  # boot for Boot Diagnostics
  # diag for VM Diagnostics
  # gen for General Purpose
}

variable "zone" {
  description = "Azure Zone example: NAZ or SAZ"
  type        = string
}

variable "auid" {
  description = "Azure Unique App ID. If resource does not have AUID then replace it with unique identifier."
  type        = string
}

variable "project_name" {
  description = "Name of the product for naming resources, example: OnePortal, Networking"
  type        = string
}

variable "application_name" {
  description = "Name of the application for tags, example, OnePortalAPI or LOLAWeb"
  type        = string
}

variable "department" {
  description = "Department for tags."
  type        = string
}

variable "business_owner_email" {
  description = "Business owner email for tags"
  type        = string
}

variable "dev_owner_email" {
  description = "Dev owner email for tags"
  type        = string
}

variable "criticality" {
  description = "Criticality of the project for tags, example: LOW or HIGH"
  type        = string
}

variable "cost_center" {
  description = "Cost center id of the project for tags"
  type        = string
}

variable "maintenance_window" {
  description = "Maintenance window for the project"
  type        = string
}

variable "additional_tags" {
  description = "Additional tagging"
  type        = map(string)
  default     = null
}

variable "environment" {
  description = "Environment for tags. Valid options are: DEV, QA, STG, NONPROD, PROD and DR."
  type        = string
}

variable "source_tool" {
  description = "IAC tool used to deploy the resource (Terraform or Terragrunt)"
  type        = string
  default     = "terraform"

  validation {
    condition     = lower(var.source_tool) == "terraform" || lower(var.source_tool) == "terragrunt"
    error_message = "Invalid source_tool value. It must be either 'terraform' or 'terragrunt'."
  }
}

variable "region" {
  description = "Environment for tags. Valid options are: DEV, QA, STG, NONPROD, PROD and DR."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = []
}

variable "create_public_subnets" {
  description = "Whether to create public subnets"
  type        = bool
  default     = false
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = map(bool)
  default     = {}
}

variable "create_nat_gateway" {
  description = "Whether to create NAT gateways"
  type        = bool
  default     = false
}

variable "nat_gateway_subnet_indexes" {
  description = "Indexes of public subnets for NAT gateways"
  type        = list(number)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "create_route_tables" {
  description = "Whether to create route tables"
  type        = bool
  default     = false
}

variable "public_route_table_names" {
  description = "Names of the public route tables to create"
  type        = list(string)
  default     = []
}

variable "public_subnet_route_table_indexes" {
  description = "Indexes of public subnets for route table associations"
  type        = list(number)
  default     = []
}

variable "public_route_table_indexes_for_association" {
  description = "Indexes of public route tables for subnet associations"
  type        = list(number)
  default     = []
}

variable "private_route_table_names" {
  description = "Names of the private route tables to create"
  type        = list(string)
  default     = []
}

variable "private_subnet_route_table_indexes" {
  description = "Indexes of private subnets for route table associations"
  type        = list(number)
  default     = []
}

variable "private_route_table_indexes_for_association" {
  description = "Indexes of private route tables for subnet associations"
  type        = list(number)
  default     = []
}

variable "public_routes" {
  description = "List of routes for public route tables"
  type = list(object({
    destination_cidr_block = string
  }))
  default = []
}

variable "private_routes" {
  description = "List of routes for private route tables"
  type = list(object({
    destination_cidr_block = string
    # nat_gateway_index         = number
  }))
  default = []
}
