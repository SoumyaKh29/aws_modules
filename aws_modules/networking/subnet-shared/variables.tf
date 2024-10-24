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

variable "subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = string
  default     = null
}

variable "sub_type" {
  description = "Subnet is private or public"
  type        = string
  validation {
    condition     = contains(["public", "private"], lower(var.sub_type))
    error_message = "The sub_type variable must be either 'Private' or 'Public'."
  }
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch for public subnets"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of the VPC where the endpoint will be created."
  type        = string
}

variable "share_subnet" {
  type        = bool
  description = "Whether to share the subnet with other AWS accounts or organizations"
  default     = false
}

variable "allow_external_principals" {
  type        = bool
  description = "Allow sharing with external AWS accounts outside your organization"
  default     = false
}

variable "principal_id" {
  type        = string
  description = "AWS Account ID or Organization ARN with which the subnet will be shared"
  default     = null
}
