# Module : Secrets Manager

## Overview

This module manages AWS Secrets Manager secrets, including optional encryption, rotation, and versioning.

## Usage

```hcl
module "secret" {
  source           = "github.com/test.git//aws/security/secret-manager"
  name             = "my-secret"
  description      = "My secret description"
  secret_string    = "{\"username\":\"admin\",\"password\":\"password\"}"
  kms_key_id       = "arn:aws:kms:region:account-id:key/key-id"
  rotation_lambda_arn = "arn:aws:lambda:region:account-id:function:function-name"
  rotation_days    = 30
}
```
## Inputs

| Name               | Description                                             | Type   | Default | Required |
|--------------------|---------------------------------------------------------|--------|---------|----------|
| `optional_num`        | Optional number appended to resource naming                 | `string`    | `null`  | No       |
| `purpose`             | Purpose of the storage account (e.g., boot, diag, gen)       | `string`    | N/A     | Yes      |
| `zone`                | Azure Zone example (e.g., NAZ or SAZ)                       | `string`    | N/A     | Yes      |
| `auid`                | Azure Unique App ID. Replace with unique identifier if none | `string`    | N/A     | Yes      |
| `project_name`        | Name of the product for naming resources (e.g., OnePortal)  | `string`    | N/A     | Yes      |
| `application_name`    | Name of the application for tags (e.g., OnePortalAPI)       | `string`    | N/A     | Yes      |
| `department`          | Department for tags                                          | `string`    | N/A     | Yes      |
| `business_owner_email`| Business owner email for tags                               | `string`    | N/A     | Yes      |
| `dev_owner_email`     | Dev owner email for tags                                    | `string`    | N/A     | Yes      |
| `criticality`         | Criticality of the project (e.g., LOW or HIGH)              | `string`    | N/A     | Yes      |
| `cost_center`         | Cost center ID for tags                                     | `string`    | N/A     | Yes      |
| `maintenance_window`  | Maintenance window for the project                          | `string`    | N/A     | Yes      |
| `additional_tags`     | Additional tagging                                          | `map(string)`| `null`  | No       |
| `environment`         | Environment for tags (e.g., DEV, QA, PROD)                  | `string`    | N/A     | Yes      |
| `source_tool`         | IAC tool used to deploy the resource (Terraform or Terragrunt) | `string`    | `terraform` | No   |
| `name`             | The name of the secret.                                  | string | n/a     | yes      |
| `description`      | The description of the secret.                           | string | `""`    | no       |
| `secret_string`    | The secret value to store.                               | string | n/a     | yes      |
| `kms_key_id`       | The ARN of the KMS key to encrypt the secret.            | string | `""`    | no       |
| `rotation_lambda_arn` | The ARN of the Lambda function used to rotate the secret. | string | `""`    | no       |
| `rotation_days`    | The number of days between automatic rotations.          | number | `30`    | no       |

## Outputs

| Name         | Description                         |
|--------------|-------------------------------------|
| `secret_id`  | The ID of the secret.               |
| `secret_arn` | The ARN of the secret.              |

## Examples
Here are 3 usage examples for the AWS Secrets Manager Terraform module, showcasing different scenarios:

### Example 1: Basic Secret Without Encryption or Rotation
```hcl
module "basic_secret" {
  source         = "github.com/test.git//aws/security/secret-manager"
  name           = "my-basic-secret"
  description    = "This is a basic secret without encryption or rotation."
  secret_string  = "{\"username\":\"admin\",\"password\":\"admin123\"}"
}
```
### Example 2: Secret with KMS Encryption
```hcl
module "kms_encrypted_secret" {
  source         = "github.com/test.git//aws/security/secret-manager"
  name           = "my-encrypted-secret"
  description    = "Secret encrypted using a custom KMS key."
  secret_string  = "{\"db_password\":\"secure-db-pass\"}"
  kms_key_id     = "arn:aws:kms:us-east-1:123456789012:key/my-kms-key-id"
}
```
### Example 3: Secret with Automatic Rotation
```hcl
module "rotating_secret" {
  source              = "github.com/test.git//aws/security/secret-manager"
  name                = "my-rotating-secret"
  description         = "Secret with automatic rotation every 60 days."
  secret_string       = "{\"api_key\":\"my-super-secure-api-key\"}"
  rotation_lambda_arn = "arn:aws:lambda:us-east-1:123456789012:function:rotateSecretLambda"
  rotation_days       = 60
}
```
Each of these examples demonstrates different configurations for AWS Secrets Manager using the Terraform module. You can modify them based on your specific requirements.