locals {
  bucket_name = "${lower(var.zone)}-${local.auid}-${var.region}-${var.environment}-${substr(var.application_name, 0, 4)}"
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

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.optional_num != null ? "${local.bucket_name}-${var.optional_num}-bkt" : "${local.bucket_name}-bkt"
  tags   = local.tagging
}

resource "aws_s3_bucket_versioning" "versioning" {
  count = try(contains(["Enabled", "Suspended", "Disabled"], var.versioning_status), false) ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  count = var.encryption != null && contains(["AES256", "aws:kms", "aws:kms:dsse"], var.encryption.sse_algorithm) ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.encryption.sse_algorithm
      kms_master_key_id = var.encryption.sse_algorithm == "AES256" ? null : var.kms_arn
    }
  }
}

resource "aws_s3_bucket_logging" "logging" {
  count         = var.logging != null ? 1 : 0
  bucket        = aws_s3_bucket.s3_bucket.id
  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix

}

data "aws_iam_policy_document" "bucket_policy" {
  dynamic "statement" {
    for_each = var.statements

    content {
      effect = statement.value.effect

      principals {
        type        = statement.value.principal_type
        identifiers = statement.value.principal_ids
      }

      actions = statement.value.actions

      resources = [
        aws_s3_bucket.s3_bucket.arn,
        "${aws_s3_bucket.s3_bucket.arn}/*",
      ]

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

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}


resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  count  = var.lifecycle_rules != null ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  dynamic "rule" {
    for_each = lookup(var.lifecycle_rules, "rules", [])
    content {
      id     = lookup(rule.value, "id", null)
      status = rule.value.status

      dynamic "filter" {
        for_each = [rule.value.filter]
        content {
          prefix = lookup(rule.value.filter, "prefix", null)

          dynamic "tag" {
            for_each = lookup(rule.value.filter, "tags", {})
            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transitions", [])
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", {}) != {} ? [1] : []
        content {
          days                         = lookup(rule.value.expiration, "days", null)
          expired_object_delete_marker = lookup(rule.value.expiration, "expired_object_delete_marker", false)
        }
      }
    }
  }
}

