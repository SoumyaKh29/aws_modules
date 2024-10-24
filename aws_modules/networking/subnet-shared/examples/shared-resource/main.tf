module "shared_subnet" {
  source = "../../"
  # Below values specify Tags
  environment               = "non-prod"
  department                = "devops"
  project_name              = "test-soumya"
  business_owner_email      = "test2@gmail.com"
  dev_owner_email           = "test@gmail.com"
  criticality               = "Low"
  cost_center               = "23456"
  maintenance_window        = "NA"
  zone                      = "GHQ"
  auid                      = "SE-00008"
  application_name          = "test-app"
  purpose                   = "gen"
  region                    = "ap-south-1"
  vpc_id                    = "vpc-12345677654323454323"
  subnet_cidrs              = "10.0.1.0/24"
  availability_zones        = "ap-south-1a"
  map_public_ip_on_launch   = true
  sub_type                  = "public"
  share_subnet              = true # Optional parameters for sharing the subnet
  allow_external_principals = false
  principal_id              = "123456789012" # AWS Account ID or Organization ARN
}
