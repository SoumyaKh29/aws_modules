locals {
  name = var.optional_num != null ? lower("${var.zone}-${local.auid}-${var.region}-${var.environment}-${substr(var.application_name, 0, 4)}-${var.optional_num}") : lower("${local.auid}-${var.region}-${substr(var.application_name, 0, 4)}")
  aws_region = lookup(
    jsondecode(file("${path.module}/../../../config/aws-regions.json")),
    var.region != "" ? var.region : data.aws_region.current.name, # Fallback to a default region
  "default-region")
  environment = lookup(
    jsondecode(file("${path.module}/../../../config/environment.json")), # Decode the file to a map
    lower(var.environment),                                              # Key lookup
    "d"                                                                  # Default value if the key is not found
  )
  auid = lower(replace(var.auid, "SE-", ""))

  tags = {

    ApplicationUID     = var.auid
    Department         = var.department
    BusinessOwnerEmail = var.business_owner_email

    SourceTool         = var.source_tool
  }
  tagging = merge(local.tags, var.additional_tags)
}

# Fetch the current region
data "aws_region" "current" {}

data "aws_iam_policy_document" "policy" {
  dynamic "statement" {
    for_each = var.statements

    content {
      sid = statement.value.sid == null ? "" : statement.value.sid
      effect = statement.value.effect
      actions = statement.value.actions
      resources = statement.value.resources
      dynamic "condition" {
        for_each = statement.value.conditions != null ? statement.value.conditions : []
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "policy" {
  name   = lower("${local.name}-policy")
  path   = var.policy_path
  policy = data.aws_iam_policy_document.policy.json
  tags   = local.tagging
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = lower("${local.name}-policy-attach")
  roles      = var.existing_role_name
  policy_arn = aws_iam_policy.policy.arn
}