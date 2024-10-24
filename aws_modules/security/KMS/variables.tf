terraform {
  required_version = ">= 1.4.6"
}

variable "zone" {
  description = "Azure Zone example: NAZ or SAZ"
  type        = string
}

variable "auid" {
  description = "Azure Unique App ID. If resource does not have AUID then replace it with unique identifier."
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

variable "key_usage" {
  description = "Specifies the intended use of the key. Valid values are ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "custom_key_store_id" {
  description = "(Optional) ID of the KMS Custom Key Store where the key will be stored instead of KMS (eg CloudHSM)."
  type        = string
  default     = null
}

variable "customer_master_key_spec" {
  description = "(Optional) Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, HMAC_256, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
  default     = ""
}

variable "bypass_policy_lockout_safety_check" {
  description = "(Optional) A flag to indicate whether to bypass the key policy lockout safety check."
  type        = bool
  default     = false
}

variable "is_enabled" {
  description = "(Optional) Specifies whether the key is enabled"
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "(Optional) Indicates whether the KMS key is a multi-Region"
  type        = bool
  default     = false
}

variable "xks_key_id" {
  description = "(Optional) Identifies the external key that serves as key material for the KMS key in an external key store"
  type        = string
  default     = ""
}

variable "enable_key_rotation" {
  description = "required to be enabled if rotation_period_in_days is specified. Specifies whether key rotation is enabled. Defaults to false"
  type        = bool
  default     = false
}

variable "rotation_period_in_days" {
  description = "Custom period of time between each rotation date. Must be a number between 90 and 2560"
  type        = number
  default     = 0

  validation {
    condition     = var.rotation_period_in_days >= 90 && var.rotation_period_in_days <= 2560
    error_message = "Input variable rotation_period_in_days must be a number between 90 and 2560"
  }
}

variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30"
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "Input variable deletion_window_in_days must be a number between 7 and 30"
  }
}

variable "kms_policy_enabled" {
  description = "Whether to enable policy for KMS resource"
  type        = bool
  default     = false
}

variable "policy_statement" {
  description = "The statement block of the KMS policy"
  type        = any
  default     = []
}


variable "policy_version" {
  description = "version (Optional) - IAM policy document version. Valid values are 2008-10-17 and 2012-10-17."
  type        = string
  default     = "2012-10-17"
}

variable "optional_num" {
  description = "Optional Number of the KMS resource"
  type        = string
  default     = null
}

variable "policy_id" {
  description = "Name of the product for naming resources, example: OnePortal, Networking"
  type        = string
  default     = "Key-default"
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