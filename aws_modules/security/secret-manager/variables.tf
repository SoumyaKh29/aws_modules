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

variable "description" {
  description = "The description of the secret."
  type        = string
  default     = ""
}

variable "create_random_password" {
  description = "Determines whether a random password will be generated"
  type        = bool
  default     = false
}

variable "random_password_length" {
  description = "The length of the generated random password"
  type        = number
  default     = 32
}

variable "random_password_override_special" {
  description = "Supply your own list of special characters to use for string generation. This overrides the default character list in the special argument"
  type        = string
  default     = "!@#$%&*()-_=+[]{}<>:?"
}

variable "secret_string" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret. This is required if `secret_binary` is not set"
  type        = map(string)
  default     = null
}

variable "secret_binary" {
  description = "Specifies binary data that you want to encrypt and store in this version of the secret. This is required if `secret_string` is not set. Needs to be encoded to base64"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The ARN of the KMS key to encrypt the secret."
  type        = string
  default     = ""
}

variable "rotation_lambda_arn" {
  description = "The ARN of the Lambda function used to rotate the secret."
  type        = string
  default     = ""
}

variable "rotation_days" {
  description = "The number of days between automatic rotations."
  type        = number
  default     = null
}
