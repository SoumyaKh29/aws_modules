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

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.identifiers
    }
  }
}

resource "aws_iam_role" "role" {
  name               = lower("${local.name}-role")
  path               = var.path
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = local.tagging
}