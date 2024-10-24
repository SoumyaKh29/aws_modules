data "aws_region" "current" {}
locals {
  name = var.optional_num == null ? "${lower(var.zone)}-${local.auid}-${var.region}-${var.environment}-${substr(var.application_name, 0, 4)}-kms" : "${lower(var.zone)}-${local.auid}-${var.region}-${var.environment}-${substr(var.application_name, 0, 4)}-${var.optional_num}-kms"
  aws_region = lookup(
    jsondecode(file("${path.module}/../../../config/aws-regions.json")),
    var.region != "" ? var.region : data.aws_region.current.name, # Fallback to a default region
  "default-region")
  environment = lookup(
    jsondecode(file("${path.module}/../../../config/environment.json")), # Decode the file to a map
    lower(var.environment),                                              # Key lookup
    "d"                                                                  # Default value if the key is not found
  )
  zone = lookup(jsondecode(file("${path.module}/../../../config/zone.json")), # Decode the file to a map
    lower(var.zone),                                                          # Key lookup
    "g"                                                                       # Default value if the key is not found
  )
  auid     = lower(replace(var.auid, "SE-", ""))
  kms_name = lower(replace(local.name, "_", "-"))
  tags = {

    ApplicationUID     = var.auid
    Department         = var.department
    BusinessOwnerEmail = var.business_owner_email

    SourceTool         = var.source_tool
  }
  tagging = merge(local.tags, var.additional_tags)
}

resource "aws_kms_key" "kms_key" {
  description                        = var.description == "" ? null : var.description
  enable_key_rotation                = var.enable_key_rotation
  deletion_window_in_days            = var.deletion_window_in_days
  tags                               = merge({ Name = local.kms_name }, local.tagging)
  key_usage                          = var.key_usage
  custom_key_store_id                = var.custom_key_store_id != null ? var.custom_key_store_id : null
  customer_master_key_spec           = var.customer_master_key_spec
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  is_enabled                         = var.is_enabled
  multi_region                       = var.multi_region
  xks_key_id                         = var.xks_key_id != "" ? var.xks_key_id : null
  rotation_period_in_days            = var.rotation_period_in_days

  policy = var.kms_policy_enabled ? jsonencode({
    Version   = var.policy_version
    Statement = var.policy_statement
  }) : jsonencode({})

}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${local.kms_name}"
  target_key_id = aws_kms_key.kms_key.arn
}