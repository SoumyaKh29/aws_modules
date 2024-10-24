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

resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidrs
  availability_zone       = var.availability_zones
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge({
    Name = lower("${local.name}-${var.sub_type}-sub")
  }, local.tagging)
}

# Resource Share (Optional)
resource "aws_ram_resource_share" "subnet_share" {
  count                     = var.share_subnet ? 1 : 0
  name                      = "${local.name}-${var.sub_type}-subnet-share"
  allow_external_principals = var.allow_external_principals
  tags = merge({
    Name = lower("${local.name}-${var.sub_type}-subnet-share")
  }, local.tagging)
}

# Associate Subnet with the Share
resource "aws_ram_resource_association" "subnet_association" {
  count              = var.share_subnet ? 1 : 0
  resource_share_arn = aws_ram_resource_share.subnet_share[0].arn
  resource_arn       = aws_subnet.subnet.arn
}

# Principal (Account or Organization) Association
resource "aws_ram_principal_association" "principal_association" {
  count              = var.share_subnet ? 1 : 0
  resource_share_arn = aws_ram_resource_share.subnet_share[0].arn
  principal          = var.principal_id # AWS Account ID or Organization ARN
}
