# S3 Bucket Terraform Module

This Terraform module creates an S3 bucket along with optional features such as versioning, encryption, logging, and lifecycle rules. The module allows for customization through various inputs and outputs the created resources.

## Features

- **S3 Bucket Creation**: Create multiple S3 buckets using naming conventions derived from variables such as region, zone, environment, and application name.
- **Versioning**: Enable or suspend versioning for specific buckets based on input.
- **Server-Side Encryption**: Configure SSE (Server-Side Encryption) with AES-256 or KMS (AWS Key Management Service) encryption.
- **Bucket Logging**: Configure logging for specific buckets.
- **Bucket Policies**: Apply custom bucket policies to buckets.
- **Lifecycle Rules**: Set lifecycle management rules for object transitions and expiration.

## Usage

```hcl
module "s3_buckets" {
  source = "github.com/test.git//aws/storage/s3-bucket"
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
```

## Inputs

| Name                  | Description                                                                       | Type     | Default       | Required |
|-----------------------|-----------------------------------------------------------------------------------|----------|---------------|----------|
| `optional_num`         | Optional number appended to resource naming                                       | `string` | `null`        | No       |
| `purpose`              | Purpose of the storage account (boot, diag, gen)                                  | `string` |               | Yes      |
| `zone`                 | Azure Zone example: NAZ or SAZ                                                    | `string` |               | Yes      |
| `auid`                 | Azure Unique App ID or unique identifier if not available                         | `string` |               | Yes      |
| `project_name`         | Name of the product for naming resources, example: OnePortal, Networking           | `string` |               | Yes      |
| `application_name`     | Name of the application for tags                                                  | `string` |               | Yes      |
| `department`           | Department for tags                                                               | `string` |               | Yes      |
| `business_owner_email` | Business owner email for tags                                                     | `string` |               | Yes      |
| `dev_owner_email`      | Dev owner email for tags                                                          | `string` |               | Yes      |
| `criticality`          | Criticality of the project for tags (LOW, HIGH)                                   | `string` |               | Yes      |
| `cost_center`          | Cost center id of the project for tags                                            | `string` |               | Yes      |
| `maintenance_window`   | Maintenance window for the project                                                | `string` |               | Yes      |
| `additional_tags`       | Additional tagging                                                                | `map(string)` | `null` | No       |
| `environment`          | Environment for tags (DEV, QA, STG, NONPROD, PROD, DR)                            | `string` |               | Yes      |
| `region`               | Region for resource creation                                                      | `string` |               | Yes      |
| `source_tool`          | IAC tool used to deploy the resource (Terraform or Terragrunt)                    | `string` | `"terraform"` | No       |
| `versioning_status`    | Status of versioning (enabled, suspended, disabled)                               | `string` | `null`        | No       |
| `encryption`           | Object containing the encryption configuration                                    | `object` |               | Yes      |
| `kms_arn`              | ARN of KMS key to be added                                                        | `string` | `null`        | No       |
| `logging`              | Logging configuration for the S3 bucket                                           | `object` | `null`        | No       |
| `statements`           | List of IAM policy statements                                                     | `list(object)` |        | Yes      |
| `lifecycle_rules`      | Lifecycle configuration for the S3 bucket                                         | `object` | `null`        | No       |

## Outputs

| Name               | Description                                 |
|--------------------|---------------------------------------------|
| `bucket_ids`        | The names of the S3 buckets                 |
| `bucket_arns`       | The ARNs of the S3 buckets                  |
| `bucket_policy_id`  | The ID of the bucket policy                 |