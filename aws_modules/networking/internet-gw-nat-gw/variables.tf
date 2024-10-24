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
variable "region" {
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

variable "create_internet_gateway" {
  description = "Wheather to create the internet gateway or not"
  type        = bool
  default = false
}

variable "vpc_id" {
  description = "The ID of the VPC where the endpoint will be created."
  type        = string
}

variable "create_nat_gateway" {
  description = "Wheather to create the Nat gateway or not"
  type        = bool
  default = false
}

variable "subnet_id" {
  description = "The Subnet ID of the subnet in which to place the NAT Gateway."
  type        = string
}

variable "allocation_id" {
  description = "The Allocation ID of the Elastic IP address for the NAT Gateway. Required for connectivity_type of public"
  type        = string
  default = null
}

variable "connectivity_type" {
  description = "The ID of the VPC where the endpoint will be created."
  type        = string
  default = null
}

variable "private_ip" {
  description = "The ID of the VPC where the endpoint will be created."
  type        = string
  default = null
}


variable "secondary_allocation_ids" {
  description = "The ID of the VPC where the endpoint will be created."
  type        = list(string)
  default = null
}

variable "secondary_private_ip_address_count" {
  description = "The ID of the VPC where the endpoint will be created."
  type        = number
  default = null
}

variable "secondary_private_ip_addresses" {
  description = "The ID of the VPC where the endpoint will be created."
  type        = list(string)
  default = null
  }
