variable "optional_num" {
  description = "Optional number appended to resource naming"
  type        = string
  default     = null
}

variable "purpose" {
  type        = string
  description = "Purpose of the storage account. Examples are: boot, diag, gen. For more info, check below."
  # boot for Boot Diagnostics
  # diag for VM Diagnostics
  # gen for General Purpose
}

variable "region" {
  description = "Environment for tags. Valid options are: DEV, QA, STG, NONPROD, PROD and DR."
  type        = string
}

variable "zone" {
  description = "Azure Zone example: NAZ or SAZ"
  type        = string
}

variable "auid" {
  description = "Azure Unique App ID. If resource does not have AUID then replace it with unique identifier."
  type        = string
}

variable "project_name" {
  description = "Name of the product for naming resources, example: OnePortal, Networking"
  type        = string
}

variable "application_name" {
  description = "Name of the application for tags, example, OnePortalAPI or LOLAWeb"
  type        = string
}

variable "department" {
  description = "Department for tags."
  type        = string
}

variable "business_owner_email" {
  description = "Business owner email for tags"
  type        = string
}

variable "dev_owner_email" {
  description = "Dev owner email for tags"
  type        = string
}

variable "criticality" {
  description = "Criticality of the project for tags, example: LOW or HIGH"
  type        = string
}

variable "cost_center" {
  description = "Cost center id of the project for tags"
  type        = string
}

variable "maintenance_window" {
  description = "Maintenance window for the project"
  type        = string
}

variable "additional_tags" {
  description = "Additional tagging"
  type        = map(string)
  default     = null
}

variable "environment" {
  description = "Environment for tags. Valid options are: DEV, QA, STG, NONPROD, PROD and DR."
  type        = string
}

variable "source_tool" {
  description = "IAC tool used to deploy the resource (Terraform or Terragrunt)"
  type        = string
  default     = "terraform"

  validation {
    condition     = lower(var.source_tool) == "terraform" || lower(var.source_tool) == "terragrunt"
    error_message = "Invalid source_tool value. It must be either 'terraform' or 'terragrunt'."
  }
}

# ==================================ecs cluster===========================================================
variable "create_ecs_cluster" {
  description = "Boolean to determine whether to create a new cluster or use already created."
  type        = bool
}

variable "settings" {
  type = map(object({
    name  = string
    value = string
  }))
  default     = {}
  description = "Cluster settings like container insights."
}
# ==================================ecs task defination=====================================================

variable "create_task_defination" {
  description = "Boolean to determine whether to create a new cluster or use already created."
  type        = bool
}

variable "cpu" {
  description = "Number of cpu units used by the task defination."
  type        = string
  default     = null
}

variable "memory" {
  description = "(Optional) Amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
  type        = string
  default     = null
}

variable "execution_role_arn" {
  description = "(Optional) ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  type        = string
  default     = null
}

variable "task_role_arn" {
  description = "(Optional) ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
  type        = string
  default     = null
}


# ==================================ecs service============================================================
variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task. Valid values are `none`, `bridge`, `awsvpc`, and `host`"
  type        = string
  default     = "awsvpc"
}

variable "scheduling_strategy" {
  description = "Scheduling strategy to use for the service. The valid values are `REPLICA` and `DAEMON`. Defaults to `REPLICA`"
  type        = string
  default     = null
}

variable "launch_type" {
  description = "Launch type on which to run your service. The valid values are `EC2`, `FARGATE`, and `EXTERNAL`. Defaults to `FARGATE`"
  type        = string
  default     = "FARGATE"
}

variable "capacity_provider_strategy" {
  description = "Capacity provider strategies to use for the service. Can be one or more"
  type = map(object({
    base              = optional(number)
    capacity_provider = string
    weight            = string
  }))
  default = {}
}

variable "deployment_circuit_breaker" {
  description = "Configuration block for deployment circuit breaker"
  type = map(object({
    enable   = bool
    rollback = bool
  }))
  default = {}
}

variable "deployment_controller" {
  description = "Configuration block for deployment controller configuration. Type of deployment controller. Valid values: CODE_DEPLOY, ECS, EXTERNAL"
  type = map(object({
    type = string
  }))
  default = {
    controller = {
      type = "ECS"
    }
  }
}

variable "deployment_maximum_percent" {
  description = "Upper limit (as a percentage of the service's `desired_count`) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit (as a percentage of the service's `desired_count`) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = 66
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service"
  type        = bool
  default     = true
}

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service"
  type        = bool
  default     = false
}

variable "force_new_deployment" {
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination, roll Fargate tasks onto a newer platform version, or immediately deploy `ordered_placement_strategy` and `placement_constraints` updates"
  type        = bool
  default     = true
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers"
  type        = number
  default     = null
}

variable "iam_role_arn" {
  type        = string
  description = "IAM Role to be assigned to ECS Service"
  default     = null
}

variable "load_balancer" {
  description = "Configuration block for load balancers"
  type = map(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  default = {}
}

variable "assign_public_ip" {
  description = "Assign a public IP address to the ENI (Fargate launch type only)"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security groups to associate with the task or service"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnets to associate with the task or service"
  type        = list(string)
  default     = []
}


variable "ordered_placement_strategy" {
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence"
  type = map(object({
    type  = string
    field = optional(string)
  }))
  default = {}
}

variable "placement_constraints" {
  description = "Configuration block for rules that are taken into consideration during task placement (up to max of 10). This is set at the service, see `task_definition_placement_constraints` for setting at the task definition"
  type = map(object({
    expression = optional(string)
    type       = string
  }))
  default = {}
}

variable "platform_version" {
  description = "Platform version on which to run your service. Only applicable for `launch_type` set to `FARGATE`. Defaults to `LATEST`"
  type        = string
  default     = null
}

variable "task_definition_arn" {
  description = "Existing task definition ARN. Required when `create_task_definition` is `false`"
  type        = string
  default     = null
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger an in-place update (redeployment). Useful with `timestamp()`"
  type        = map(string)
  default     = {}
}

variable "wait_for_steady_state" {
  description = "If true, Terraform will wait for the service to reach a steady state before continuing. Default is `false`"
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the service"
  type        = map(string)
  default     = {}
}