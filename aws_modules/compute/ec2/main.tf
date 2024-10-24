locals {
  name          = lower("${local.auid}-${var.region}-${substr(var.application_name, 0, 4)}")
  instance      = lower("${var.zone}${local.auid}${var.region}${var.environment}${var.tier}")
  instance_name = var.os_type == "linux" ? "${local.instance}l" : "${local.instance}w"

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

# IAM Role for EC2 to access Secrets Manager
resource "aws_iam_role" "ec2_role" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.optional_num != null ? lower("${local.name}${var.optional_num}-ec2-role") : lower("${local.name}-ec2-role")
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "${var.role_effect}"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.optional_num != null ? lower("${local.name}${var.optional_num}-ec2-policy") : lower("${local.name}-ec2-policy")
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "${var.policy_action}"
      Effect   = "${var.policy_effect}"
      Resource = "${var.resources}"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  count      = var.create_instance_profile ? 1 : 0
  role       = aws_iam_role.ec2_role[0].name
  policy_arn = aws_iam_policy.ec2_policy[0].arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.optional_num != null ? lower("${local.name}${var.optional_num}-ec2-profile") : lower("${local.name}-ec2-profile")
  role  = aws_iam_role.ec2_role[0].name
}

resource "tls_private_key" "ssh_key" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_ssh_key" {
  count      = var.create_ssh_key ? 1 : 0
  key_name   = var.optional_num != null ? lower("${local.name}${var.optional_num}-ec2-ssh-key") : lower("${local.name}-ec2-ssh-key")
  public_key = tls_private_key.ssh_key[0].public_key_openssh
}

# EC2 Instances
resource "aws_instance" "this" {
  for_each          = var.instances
  ami               = each.value.ami
  instance_type     = each.value.instance_type
  availability_zone = each.value.availability_zone
  subnet_id         = each.value.subnet_id
  # tenancy           = each.value.tenancy
  # Optional Spot Instance Configuration
  dynamic "instance_market_options" {
    for_each = lookup(each.value, "spot_instance", null) != null ? [1] : []
    content {
      market_type = "spot"

      spot_options {
        instance_interruption_behavior = lookup(each.value.spot_instance, "instance_interruption_behavior", "terminate")
        max_price                      = lookup(each.value.spot_instance, "max_price", null)
      }
    }
  }

  # Use SSH Key Pair if specified
  key_name = var.use_ssh ? (var.create_ssh_key ? "${aws_key_pair.generated_ssh_key[0].key_name}" : var.ssh_key_name) : null
  # Optional Network Interfaces
  dynamic "network_interface" {
    for_each = lookup(each.value, "network_interfaces", [])
    content {
      network_interface_id  = network_interface.value.network_interface_id
      device_index          = network_interface.value.device_index
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  # Optional Credit Specification
  dynamic "credit_specification" {
    for_each = lookup(each.value, "credit_specification", null) != null ? [1] : []
    content {
      cpu_credits = lookup(each.value.credit_specification, "cpu_credits", "standard")
    }
  }

  # Optional CPU Options
  dynamic "cpu_options" {
    for_each = (lookup(each.value, "cpu_options", null) != null && lookup(each.value, "instance_type", null) == null) ? [1] : []
    content {
      core_count       = lookup(each.value.cpu_options, "core_count", null)
      threads_per_core = lookup(each.value.cpu_options, "threads_per_core", null)
    }
  }

  # Optional Maintenance Options
  dynamic "maintenance_options" {
    for_each = lookup(each.value, "maintenance_options", null) != null ? [1] : []
    content {
      auto_recovery = lookup(each.value.maintenance_options, "auto_recovery", "default")
    }
  }

  # Optional User Data
  user_data = lookup(each.value, "user_data", null)

  # Optional EBS Volumes
  dynamic "ebs_block_device" {
    for_each = lookup(each.value, "ebs", [])
    content {
      device_name           = lookup(ebs_block_device.value, "device_name", null)
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = lookup(ebs_block_device.value, "volume_type", "gp2")
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
    }
  }

  # Optional EBS Attachments
  dynamic "ebs_block_device" {
    for_each = lookup(each.value, "ebs_attachments", [])
    content {
      device_name = lookup(ebs_block_device.value, "device_name", null)
      volume_size = ebs_block_device.value.volume_size
    }
  }

  iam_instance_profile = var.create_instance_profile ? "${aws_iam_instance_profile.ec2_profile[0].name}" : null
  tags = merge({
    Name = ("${var.optional_num}" != null ? ("${local.instance_name}${index(values(var.instances), each.value) + 1}${var.optional_num}") : ("${local.instance_name}${index(values(var.instances), each.value) + 1}"))
  }, local.tagging)
}
