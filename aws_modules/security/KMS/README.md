# Terraform AWS KMS Key Module

This Terraform module creates an AWS KMS (Key Management Service) key along with an alias. It allows you to manage KMS keys easily by configuring various parameters, including key policies, tags, and descriptions.

## Table of Contents

- [Requirements](#requirements)
- [Usage](#usage)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Examples](#examples)
- [License](#license)

## Requirements

- Terraform 1.x or later
- AWS Provider for Terraform

## Usage

To use this module, include it in your Terraform configuration:

#### main.tf

```terraform
#Creates KMS Key with multiple statements
module "test_aws_kms_key" {
  source = "github.com/test.git/aws/security/KMS?ref=v1.0.0"

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

  region                  = "ap-south-1"
  enable_key_rotation     = true
  rotation_period_in_days = 91
  deletion_window_in_days = 25
  kms_policy_enabled      = true
  policy_statement = [
    {
      "Effect": "Allow"
      "Principal": {
          "AWS": "arn:aws:iam::{ACCOUNTID}:root"
      },
      "Action": ["kms:*"],
      "Resource": ["*"]
    },{
      "Effect": "Allow" 
      "Principal": {
          "AWS": "arn:aws:iam::{ACCOUNTID}:root"
        },
      "Action": ["ec2:*"]
    }
  ]
  
}

```