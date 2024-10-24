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

variable "region" {
  description = "Environment for tags. Valid options are: DEV, QA, STG, NONPROD, PROD and DR."
  type        = string
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

variable "tier" {
  description = "Tier of the application"
  type        = string
  validation {
    condition     = length(var.tier) < 3
    error_message = "Invalid Value for tier. Length of tier should be less than 3"
  }
}

variable "os_type" {
  description = "OS type for the VM to be created"
  type        = string

  validation {
    condition     = contains(["linux", "windows"], lower(var.os_type))
    error_message = "The os_type variable must be either 'linux' or 'windows'."
  }
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

variable "role_effect" {
  description = "Effect of the role"
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["allow", "deny"], lower(var.role_effect))
    error_message = "The role_effect variable must be either 'Allow' or 'Deny'."
  }
}

variable "policy_effect" {
  description = "Effect of the policy"
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["allow", "deny"], lower(var.policy_effect))
    error_message = "The role_effect variable must be either 'Allow' or 'Deny'."
  }
}

variable "policy_action" {
  description = "A list of actions that are allowed for the principals"
  type        = list(string)
  default     = ["s3:ListBucket", "s3:GetObject"]
}

variable "resources" {
  description = "The resources the policy applies to"
  type        = list(string)
  default     = ["*"]
}

variable "instances" {
  description = "Map of EC2 instance configurations"
  type = map(object({
    ami               = optional(string, null)
    instance_type     = string
    availability_zone = string
    subnet_id         = optional(string, null)
    # tenancy           = string

    spot_instance = optional(object({
      instance_interruption_behavior = optional(string, "terminate")
      max_price                      = optional(string)
    }), null)
    network_interfaces = optional(list(object({
      network_interface_id  = string
      device_index          = number
      delete_on_termination = optional(bool, false)
    })), [])
    credit_specification = optional(object({
      cpu_credits = optional(string, "standard")
    }), null)
    cpu_options = optional(object({
      core_count       = optional(number)
      threads_per_core = optional(number)
    }), null)
    maintenance_options = optional(object({
      auto_recovery = optional(string, "default")
    }), null)
    user_data = optional(string, null)
    ebs = optional(list(object({
      device_name           = string
      volume_size           = number
      volume_type           = optional(string, "gp2")
      delete_on_termination = optional(bool, true)
      iops                  = optional(number)
      throughput            = optional(number)
    })), [])
    ebs_attachments = optional(list(object({
      device_name = string
      volume_size = number
    })), [])
  }))
}

variable "use_ssh" {
  description = "Whether to use SSH key pair for access"
  type        = bool
  default     = true
}

variable "create_ssh_key" {
  description = "Boolean to determine whether to create a new SSH key pair."
  type        = bool
  default     = false
}

variable "ssh_key_name" {
  description = "SSH key pair name for the instance"
  type        = string
  default     = null
}

variable "create_instance_profile" {
  description = "Whether to use AWS Secrets Manager for password management"
  type        = bool
  default     = false
}
