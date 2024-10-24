locals {
  vpc_name = lower("${local.auid}-${var.region}-${substr(var.application_name, 0, 4)}")

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

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge({
    Name = var.optional_num != null ? "${local.vpc_name}-${var.optional_num}-vpc" : "${local.vpc_name}-vpc"
    }, local.tagging
  )
}

resource "aws_internet_gateway" "this" {
  count  = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${local.vpc_name}-igw"
  }, local.tagging)
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = lookup(var.map_public_ip_on_launch, count.index, false)

  tags = merge({
    Name = "${local.vpc_name}-public-sub-${count.index}"
  }, local.tagging)
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge({
    Name = "${local.vpc_name}-private-sub-${count.index}"
  }, local.tagging)
}

resource "aws_nat_gateway" "nat" {
  count         = var.create_nat_gateway ? length(var.nat_gateway_subnet_indexes) : 0
  subnet_id     = element(aws_subnet.public.*.id, var.nat_gateway_subnet_indexes[count.index])
  allocation_id = aws_eip.nat[count.index].id

  tags = merge({
    Name = "${local.vpc_name}-nat-gw-${count.index}"
  }, local.tagging)
}

resource "aws_eip" "nat" {
  count = var.create_nat_gateway ? length(var.nat_gateway_subnet_indexes) : 0
}

resource "aws_route_table" "public" {
  count  = length(var.public_route_table_names)
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.public_routes
    content {
      cidr_block = route.value.destination_cidr_block
      gateway_id = aws_internet_gateway.this[0].id
    }
  }

  tags = merge({
    Name = "${local.vpc_name}-${var.public_route_table_names[count.index]}-rt"
  }, local.tagging)
}

resource "aws_route_table" "private" {
  count  = length(var.private_route_table_names)
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.private_routes
    content {
      cidr_block     = route.value.destination_cidr_block
      nat_gateway_id = aws_nat_gateway.nat[count.index].id
    }
  }

  tags = merge({
    Name = "${local.vpc_name}-${var.private_route_table_names[count.index]}-rt"
  }, local.tagging)
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_route_table_indexes)
  subnet_id      = element(aws_subnet.public.*.id, var.public_subnet_route_table_indexes[count.index])
  route_table_id = element(aws_route_table.public.*.id, var.public_route_table_indexes_for_association[count.index])
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_route_table_indexes)
  subnet_id      = element(aws_subnet.private.*.id, var.private_subnet_route_table_indexes[count.index])
  route_table_id = element(aws_route_table.private.*.id, var.private_route_table_indexes_for_association[count.index])
}
