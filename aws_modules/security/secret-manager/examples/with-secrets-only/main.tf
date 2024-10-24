module "secret" {
  source = "../../"
  # Below values specify Tags
  environment                      = "non-prod"
  department                       = "devops"
  project_name                     = "test-soumya"
  business_owner_email             = "test2@gmail.com"
  dev_owner_email                  = "test@gmail.com"
  criticality                      = "Low"
  cost_center                      = "23456"
  maintenance_window               = "NA"
  zone                             = "GHQ"
  auid                             = "00008"
  application_name                 = "test-app"
  purpose                          = "gen"
  region                           = "ap-south-1"
  create_random_password           = true
  random_password_length           = 64
  random_password_override_special = "!@#$%^&*()_+"
  description                      = "Username and password"
}
