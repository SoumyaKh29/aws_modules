module "test_aws_kms_key" {
  source = "../"

  auid                 = "policy"
  environment          = "test"
  department           = "global"
  cost_center          = "123"
  criticality          = "low"
  business_owner_email = "test2@gmail.com"
  dev_owner_email      = "test2@gmail.com"
  maintenance_window   = "NA"
  application_name     = "initiative_check"
  zone                 = "global"
  additional_tags      = { ApplicationUID = "policy" }

  region                   = "ap-south-1"
  enable_key_rotation      = true
  rotation_period_in_days  = 91
  deletion_window_in_days  = 25
  kms_policy_enabled       = true
  customer_master_key_spec = "RSA_2048"
  policy_statement = [
    {
      "Effect" : "Allow"
      "Principal" : {
        "AWS" : "arn:aws:iam::123456567867:root"
      },
      "Action" : ["kms:*"],
      "Resource" : ["*"]
      }, {
      "Effect" : "Allow"
      "Principal" : {
        "AWS" : "arn:aws:iam::123456567867:root"
      },
      "Action" : ["ec2:*"]
    }
  ]

}
