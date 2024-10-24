module "ignat" {
  source = "../../"
  # Below values specify Tags
  environment             = "non-prod"
  department              = "devops"
  project_name            = "aws"
  business_owner_email    = "test2@gmail.com"
  dev_owner_email         = "test2@gmail.com"
  criticality             = "Low"
  cost_center             = "23456"
  maintenance_window      = "NA"
  zone                    = "GHQ"
  auid                    = "00008"
  application_name        = "app"
  purpose                 = "gen"
  region                  = "ap-south-1"
  vpc_id                  = "vpc-1123454323454323454"
  subnet_id               = "subnet-23434545676567654343"
  create_internet_gateway = true
  create_nat_gateway      = true
}
