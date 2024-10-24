module "s3_buckets" {
  source               = "../../"
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
  region               = "ap-south-1" # This bucket will be created in the us-west-2 region
  statements = [
    {
      effect        = "Allow"
      principal_type = "AWS"
      principal_ids  = ["123456567867"]
      actions       = ["s3:GetObject", "s3:ListBucket"]
    }
  ]
  encryption = {
  sse_algorithm = "AES256"
}
}


