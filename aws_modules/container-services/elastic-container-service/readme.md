# AWS ECS Cluster and Service Module

This Terraform module creates an ECS Cluster and an ECS Service in AWS with customizable configurations for deployment, networking, load balancing, and more. The module is highly configurable, providing options for advanced deployment strategies like capacity providers, deployment circuit breakers, custom tags, and network settings.

## Features

- Creates an ECS Cluster (optional).
- Manages ECS Service configuration.
- Customizable capacity provider strategies.
- Supports Fargate, EC2, and external launch types.
- Load balancer configuration.
- Network settings (subnets, security groups).
- Deployment configuration options (circuit breaker, controller, scheduling strategy).
- Tag management and propagation.

## Usage

```hcl
module "ecs_service" {
  source = "./path-to-module"

  # Cluster
  create_ecs_cluster = true
  settings           = {
    containerInsights = {
      name  = "containerInsights"
      value = "enabled"
    }
  }

  # Service
  network_mode              = "awsvpc"
  scheduling_strategy       = "REPLICA"
  launch_type               = "FARGATE"
  capacity_provider_strategy = {
    strategy_1 = {
      base              = 1
      capacity_provider = "FARGATE_SPOT"
      weight            = "2"
    }
  }
  
  deployment_controller = {
    ecs = {
      type = "ECS"
    }
  }

  subnet_ids          = ["subnet-12345678", "subnet-87654321"]
  security_group_ids  = ["sg-12345678"]
  task_definition_arn = "arn:aws:ecs:region:account-id:task-definition/your-task-def"
  desired_count       = 2
}
```

## Inputs

| Name                            | Description                                                  | Type          | Default                | Required |
|---------------------------------|--------------------------------------------------------------|---------------|------------------------|----------|
| `optional_num`                  | Optional number appended to resource naming                  | `string`      | `null`                 | no       |
| `purpose`                       | Purpose of the storage account (boot, diag, gen)             | `string`      | n/a                    | yes      |
| `region`                        | Environment for tags (DEV, QA, STG, NONPROD, PROD, DR)       | `string`      | n/a                    | yes      |
| `zone`                          | Azure Zone (NAZ, SAZ)                                        | `string`      | n/a                    | yes      |
| `auid`                          | Azure Unique App ID or unique identifier                     | `string`      | n/a                    | yes      |
| `project_name`                  | Name of the project for resource naming                      | `string`      | n/a                    | yes      |
| `application_name`              | Application name for tags                                    | `string`      | n/a                    | yes      |
| `department`                    | Department for tags                                          | `string`      | n/a                    | yes      |
| `business_owner_email`          | Business owner email for tags                                | `string`      | n/a                    | yes      |
| `dev_owner_email`               | Dev owner email for tags                                     | `string`      | n/a                    | yes      |
| `criticality`                   | Criticality level (LOW, HIGH)                                | `string`      | n/a                    | yes      |
| `cost_center`                   | Cost center ID                                               | `string`      | n/a                    | yes      |
| `maintenance_window`            | Maintenance window for the project                           | `string`      | n/a                    | no       |
| `additional_tags`               | Additional tags to add                                       | `map(string)` | `{}`                   | no       |
| `environment`                   | Environment for tags (DEV, QA, STG, NONPROD, PROD, DR)        | `string`      | n/a                    | yes      |
| `source_tool`                   | IAC tool used (Terraform or Terragrunt)                      | `string`      | `terraform`            | no       |
| `create_ecs_cluster`            | Whether to create a new ECS cluster                          | `bool`        | `false`                | no       |
| `settings`                      | Cluster settings like container insights                     | `map(object)` | `{}`                   | no       |
| `network_mode`                  | Docker networking mode (`none`, `bridge`, `awsvpc`, `host`)  | `string`      | `awsvpc`               | no       |
| `scheduling_strategy`           | Scheduling strategy (`REPLICA`, `DAEMON`)                    | `string`      | `REPLICA`              | no       |
| `launch_type`                   | Launch type for service (`EC2`, `FARGATE`, `EXTERNAL`)       | `string`      | `FARGATE`              | no       |
| `capacity_provider_strategy`    | Capacity provider strategies for the service                 | `map(object)` | `{}`                   | no       |
| `deployment_circuit_breaker`    | Configuration block for deployment circuit breaker           | `map(object)` | `{}`                   | no       |
| `deployment_controller`         | Deployment controller configuration                          | `map(object)` | `{}`                   | no       |
| `deployment_maximum_percent`    | Maximum running tasks during deployment                      | `number`      | `200`                  | no       |
| `deployment_minimum_healthy_percent` | Minimum healthy tasks during deployment                 | `number`      | `66`                   | no       |
| `desired_count`                 | Number of task instances to run                              | `number`      | `1`                    | no       |
| `enable_ecs_managed_tags`       | Enable ECS-managed tags                                      | `bool`        | `true`                 | no       |
| `enable_execute_command`        | Enable ECS Exec for tasks                                    | `bool`        | `false`                | no       |
| `force_new_deployment`          | Force new deployment for service                             | `bool`        | `true`                 | no       |
| `health_check_grace_period_seconds` | Grace period for load balancer health checks             | `number`      | `0`                    | no       |
| `iam_role_arn`                  | IAM Role ARN for ECS Service                                 | `string`      | `null`                 | no       |
| `load_balancer`                 | Load balancer configuration                                  | `map(object)` | `{}`                   | no       |
| `assign_public_ip`              | Assign public IP for Fargate launch type                     | `bool`        | `false`                | no       |
| `security_group_ids`            | Security groups to associate with the service                | `list(string)`| `[]`                   | no       |
| `subnet_ids`                    | Subnets to associate with the service                        | `list(string)`| `[]`                   | no       |
| `ordered_placement_strategy`    | Task placement strategy rules                                | `map(object)` | `{}`                   | no       |
| `placement_constraints`         | Task placement constraints                                   | `map(object)` | `{}`                   | no       |
| `platform_version`              | Platform version for Fargate services                        | `string`      | `LATEST`               | no       |
| `task_definition_arn`           | Existing task definition ARN                                 | `string`      | n/a                    | yes      |
| `triggers`                      | Arbitrary keys/values to trigger redeployment                | `map(string)` | `{}`                   | no       |
| `wait_for_steady_state`         | Wait for the service to reach a steady state                 | `bool`        | `false`                | no       |
| `propagate_tags`                | Propagate tags from task or service (`SERVICE`, `TASK_DEFINITION`) | `string` | `SERVICE`              | no       |
| `timeouts`                      | Timeout configurations for create, update, delete operations | `map(string)` | `{}`                   | no       |


## Outputs

| Name                 | Description                           |
|----------------------|---------------------------------------|
| `ecs_service_id`      | ARN that identifies the ECS service.  |
| `ecs_cluster_arn`     | The ARN of the ECS cluster.           |
| `ecs_cluster_name`    | The name of the ECS cluster.          |
