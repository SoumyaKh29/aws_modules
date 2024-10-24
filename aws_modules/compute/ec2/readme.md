# EC2 Instance Terraform Module

This Terraform module provisions multiple EC2 instances with flexible configurations. It supports spot instances, custom network configurations, CPU options, user data, and EBS attachments. It also provides the ability to configure SSH key-based authentication or manage passwords via AWS Secrets Manager, with optional KMS encryption.

## Features
* Supports Spot Instance configurations.
* Configurable network interfaces and credit specifications.
* Optional user data and EBS attachments.
* Customizable CPU options and maintenance windows.
* Supports password management with SSH keys or AWS Secrets Manager.
* Optional KMS encryption for passwords stored in Secrets Manager.

## Usage

```hcl
module "ec2_instances" {
  source = "github.com/test.git//aws/compute/ec2"

  tier                    = "ad"
  os_type                 = "linux"
  create_instance_profile = false
  use_ssh                 = true
  create_ssh_key          = true

  instances = {
    instance1 = {
      ami               = "ami-12345678"
      instance_type     = "t3.micro"
      availability_zone = "us-west-2a"
      subnet_id         = "subnet-123456"
      spot_instance     = {
        spot_price                      = "0.05"
        instance_interruption_behaviour = "terminate"
      }
      network_interfaces = [
        {
          network_interface_id = "eni-12345678"
          device_index         = 0
          delete_on_termination = true
        }
      ]
      credit_specification = {
        cpu_credits = "unlimited"
      }
      cpu_options = {
        core_count       = 2
        threads_per_core = 2
      }
      maintenance_options = {
        auto_recovery = "default"
      }
      user_data = "echo Hello, World!"
      ebs = [
        {
          volume_size           = 8
          volume_type           = "gp2"
          delete_on_termination = true
        }
      ]
      ebs_attachments = [
        {
          device_name = "/dev/sdh"
          volume_id   = "vol-12345678"
        }
      ]
    },
    instance2 = {
      ami               = "ami-87654321"
      instance_type     = "t3.micro"
      availability_zone = "us-west-2b"
      subnet_id         = "subnet-654321"
    }
  }
}
```

## Input
| Name                     | Description                                                                                             | Type             | Default              | Required |
|--------------------------|---------------------------------------------------------------------------------------------------------|------------------|----------------------|----------|
| `optional_num`            | Optional number appended to resource naming                                                             | `string`         | `null`               | No       |
| `purpose`                 | Purpose of the storage account. Examples are: boot, diag, gen                                            | `string`         |                      | Yes      |
| `region`                  | Environment for tags. Valid options are: DEV, QA, STG, NONPROD, PROD, DR                                 | `string`         |                      | Yes      |
| `zone`                    | Azure Zone example: NAZ or SAZ                                                                           | `string`         |                      | Yes      |
| `auid`                    | Azure Unique App ID. If resource does not have AUID, replace it with a unique identifier                 | `string`         |                      | Yes      |
| `project_name`            | Name of the product for naming resources, example: OnePortal, Networking                                 | `string`         |                      | Yes      |
| `application_name`        | Name of the application for tags, example, OnePortalAPI or LOLAWeb                                       | `string`         |                      | Yes      |
| `department`              | Department for tags                                                                                      | `string`         |                      | Yes      |
| `business_owner_email`    | Business owner email for tags                                                                            | `string`         |                      | Yes      |
| `dev_owner_email`         | Dev owner email for tags                                                                                 | `string`         |                      | Yes      |
| `criticality`             | Criticality of the project for tags, example: LOW or HIGH                                                | `string`         |                      | Yes      |
| `cost_center`             | Cost center ID of the project for tags                                                                   | `string`         |                      | Yes      |
| `maintenance_window`      | Maintenance window for the project                                                                       | `string`         |                      | Yes      |
| `additional_tags`         | Additional tagging                                                                                       | `map(string)`    | `null`               | No       |
| `environment`             | Environment for tags. Valid options are: DEV, QA, STG, NONPROD, PROD, DR                                 | `string`         |                      | Yes      |
| `tier`                    | Tier of the application                                                                                  | `string`         |                      | Yes      |
| `os_type`                 | OS type for the VM to be created                                                                         | `string`         |                      | Yes      |
| `source_tool`             | IAC tool used to deploy the resource (Terraform or Terragrunt)                                           | `string`         | `"terraform"`        | No       |
| `role_effect`             | Effect of the role                                                                                       | `string`         | `"Allow"`            | No       |
| `policy_effect`           | Effect of the policy                                                                                     | `string`         | `"Allow"`            | No       |
| `policy_action`           | A list of actions that are allowed for the principals                                                    | `list(string)`   | `["s3:ListBucket", "s3:GetObject"]` | No    |
| `resources`               | The resources the policy applies to                                                                      | `list(string)`   | `["*"]`              | No       |
| `instances`               | Map of EC2 instance configurations                                                                       | `map(object)`    |                      | Yes      |
| `use_ssh`                 | Whether to use SSH key pair for access                                                                   | `bool`           | `true`               | No       |
| `create_ssh_key`          | Boolean to determine whether to create a new SSH key pair                                                | `bool`           | `false`              | No       |
| `ssh_key_name`            | SSH key pair name for the instance                                                                       | `string`         | `null`               | No       |
| `create_instance_profile` | Whether to use AWS Secrets Manager for password management                                               | `bool`           | `false`              | No       |


## Outputs

| Name               | Description                                                   |
|--------------------|---------------------------------------------------------------|
| `instance_ids`     | The IDs of the EC2 instances.                                 |
| `public_ips`       | The public IP addresses of the EC2 instances.                 |
| `private_ips`      | The private IP addresses of the EC2 instances.                |

## Example Configuration

```hcl
module "ec2_instances" {
  source = "github.com/test.git//aws/compute/ec2"

  tier                    = "ad"
  os_type                 = "linux"
  create_instance_profile = true
  use_ssh                 = true
  create_ssh_key          = true

  instances = {
    instance1 = {
      ami               = "ami-3456tygfder456t"
      instance_type     = "t3.medium"
      availability_zone = "us-west-2a"
      subnet_id         = "subnet-0bb1c79de3EXAMPLE"
      ebs = [
        {
          volume_size           = 50
          volume_type           = "gp2"
          delete_on_termination = true
        }
      ]
      associate_public_ip_address = true
      tags = {
        Name = "MyInstance1"
      }
    }
  }
}
```