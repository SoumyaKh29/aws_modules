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

resource "aws_internet_gateway" "this" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = var.vpc_id

  tags = merge({
    Name = "${local.name}-igw"
  }, local.tagging)
}

resource "aws_nat_gateway" "nat" {
  count                              = var.create_nat_gateway ? 1 : 0
  subnet_id                          = var.subnet_id
  allocation_id                      = var.allocation_id
  connectivity_type                  = var.connectivity_type
  private_ip                         = var.private_ip
  secondary_allocation_ids           = var.secondary_allocation_ids
  secondary_private_ip_address_count = var.secondary_private_ip_address_count
  secondary_private_ip_addresses     = var.secondary_private_ip_addresses
  tags = merge({
    Name = "${local.name}-nat-gw"
  }, local.tagging)
}
