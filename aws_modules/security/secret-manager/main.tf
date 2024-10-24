#fetching current region
data "aws_region" "current" {}

locals {
  secret_name = "${lower(var.zone)}-${local.auid}-${var.region}-${var.environment}-${substr(var.application_name, 0, 4)}"

  auid = lower(replace(var.auid, "SE-", ""))

  tags = {

    ApplicationUID     = var.auid
    Department         = var.department
    BusinessOwnerEmail = var.business_owner_email

    SourceTool         = var.source_tool
  }
  tagging = merge(local.tags, var.additional_tags)
}

resource "aws_secretsmanager_secret" "this" {
  name        = var.optional_num != null ? "${local.secret_name}-${var.optional_num}-scm" : "${local.secret_name}-scm"
  description = var.description
  kms_key_id  = var.kms_key_id != "" ? var.kms_key_id : null
  tags        = local.tagging
}

resource "random_password" "this" {
  count = var.create_random_password ? 1 : 0

  length           = var.random_password_length
  special          = true
  override_special = var.random_password_override_special
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.create_random_password ? random_password.this[0].result : jsonencode(var.secret_string)
  secret_binary = var.secret_binary

}

resource "aws_secretsmanager_secret_rotation" "this" {
  count               = var.rotation_days != null ? 1 : 0
  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_days
  }
}

