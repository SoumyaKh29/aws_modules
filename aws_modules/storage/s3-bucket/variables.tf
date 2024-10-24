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

variable "versioning_status" {
  description = "Status of versioning don't add the variable if you dont want to enable it"
  type        = string
  validation {
    condition = contains(["enabled", "suspended","disabled",""], try(lower(var.versioning_status),""))
    error_message = "Value can be only Enabled, Suspended or Disabled"
  }
  default = null
}

variable "encryption" {
  description = "Object containing the encryption configuration for S3 buckets"
  type = object({
    sse_algorithm  = string                   # The server-side encryption algorithm (AES256, aws:kms, aws:kms:dsse)
    kms_key_arn    = optional(string, null)   # Optional KMS key ARN for aws:kms encryption (null if AES256)
  })
}

variable "kms_arn" {
  description = "ARN of kms key to be added in "
  type        = string
  default = null
}

variable "logging" {
  description = "Logging configuration for the S3 bucket"
  type = object({
    target_bucket          = string
    target_prefix          = string
  })
  default = null
}

variable "statements" {
  description = "List of IAM policy statements."
  type = list(object({
    effect        = optional(string , "Allow")
    principal_type = string
    principal_ids  = list(string)
    actions       = list(string)
    conditions     = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
}


variable "lifecycle_rules" {
  description = "Lifecycle configuration for the S3 bucket"
  type = object({
    rules = list(object({
      id       = string
      status   = string
      filter   = object({
        prefix = optional(string)
        tags   = optional(map(string))
      })
      transitions = optional(list(object({
        days          = number
        storage_class = string
      })))
      expiration = optional(object({
        days                         = number
        expired_object_delete_marker = optional(bool)
      }))
    }))
  })
  default = null
}




