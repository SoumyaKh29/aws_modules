module "vpc" {
  source = "../../"
  # Below values specify Tags
  environment          = "non-prod"
  department           = "devops"
  project_name         = "test-soumya"
  business_owner_email = "test2@gmail.com"
  dev_owner_email      = "test@gmail.com"
  criticality          = "Low"
  cost_center          = "23456"
  maintenance_window   = "NA"
  zone                 = "GHQ"
  auid                 = "SE-00008"
  application_name     = "test-app"
  purpose              = "gen"
  region               = "ap-south-1"

  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

  # Public Subnets
  create_public_subnets = true
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  map_public_ip_on_launch = {
    0 = true,
    1 = false,
    2 = true
  }

  # Private Subnets
  private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]

  # NAT Gateways
  create_nat_gateway         = true
  nat_gateway_subnet_indexes = [0, 2]

  # Route Tables for Public Subnets
  create_route_tables                        = true
  public_route_table_names                   = ["public-1", "public-2"]
  public_subnet_route_table_indexes          = [0, 1]
  public_route_table_indexes_for_association = [0, 0]

  # Route Tables for Private Subnets
  private_route_table_names                   = ["private-1", "private-2"]
  private_subnet_route_table_indexes          = [0, 1]
  private_route_table_indexes_for_association = [0, 1]

  # Routes for Route Tables
  public_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
    }
  ]

  private_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      # nat_gateway_index         = 0
    }
  ]

}
