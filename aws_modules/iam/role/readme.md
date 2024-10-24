# IAM Role Module

This Terraform module creates an IAM role with an optional assume role policy and tags.

## Inputs

| Name                | Description                                                                                  | Type          | Default     | Required |
|---------------------|----------------------------------------------------------------------------------------------|---------------|-------------|----------|
| `optional_num`       | Optional number appended to resource naming.                                                 | `string`      | `null`      | no       |
| `purpose`            | Purpose of the storage account (e.g., boot, diag, gen).                                      | `string`      | n/a         | yes      |
| `zone`               | Azure Zone (e.g., NAZ or SAZ).                                                               | `string`      | n/a         | yes      |
| `auid`               | Azure Unique App ID or a unique identifier if not available.                                 | `string`      | n/a         | yes      |
| `project_name`       | Name of the product for naming resources (e.g., OnePortal, Networking).                      | `string`      | n/a         | yes      |
| `application_name`   | Name of the application for tags (e.g., OnePortalAPI, LOLAWeb).                              | `string`      | n/a         | yes      |
| `department`         | Department for tags.                                                                         | `string`      | n/a         | yes      |
| `business_owner_email` | Business owner email for tags.                                                             | `string`      | n/a         | yes      |
| `dev_owner_email`    | Dev owner email for tags.                                                                    | `string`      | n/a         | yes      |
| `criticality`        | Criticality of the project for tags (e.g., LOW, HIGH).                                       | `string`      | n/a         | yes      |
| `cost_center`        | Cost center ID for tags.                                                                     | `string`      | n/a         | yes      |
| `maintenance_window` | Maintenance window for the project.                                                          | `string`      | n/a         | yes      |
| `additional_tags`    | Additional tagging as a map of strings.                                                      | `map(string)` | `null`      | no       |
| `environment`        | Environment for tags (e.g., DEV, QA, STG, NONPROD, PROD, DR).                                | `string`      | n/a         | yes      |
| `region`             | AWS region for the resource.                                                                 | `string`      | n/a         | yes      |
| `source_tool`        | IAC tool used to deploy the resource (`terraform` or `terragrunt`).                          | `string`      | `"terraform"` | no       |
| `statements`         | List of IAM policy statements with optional conditions.                                      | `list(object)`| n/a         | yes      |
| `existing_role_name` | List of IAM role names to use for Step Function.                                              | `list(string)`| `null`      | no       |
| `policy_path`        | Path of IAM policies to use for Step Function.                                                | `string`      | `null`      | no       |

## Outputs

| Name                 | Description                                  |
|----------------------|----------------------------------------------|
| `iam_role_name`       | The name of the IAM role created.            |
| `iam_role_arn`        | The ARN of the IAM role created.             |
| `role_assume_policy`  | The assume role policy document for the IAM role. |
| `role_tags`           | The tags applied to the IAM role.            |

## Example Usage
```hcl
module "iam_role" {
  source               = "github.com/test.git//aws/iam/role"
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
  identifiers          = ["ec2.amazonaws.com"]
}
```