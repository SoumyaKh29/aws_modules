locals {
  name = var.optional_num != null ? lower("${var.zone}-${local.auid}-${var.region}-${var.environment}-${substr(var.application_name, 0, 4)}-${var.optional_num}") : lower("${local.auid}-${var.region}-${substr(var.application_name, 0, 4)}")

  auid = lower(replace(var.auid, "SE-", ""))
  tags = {
    ApplicationUID     = var.auid
    Department         = var.department
    BusinessOwnerEmail = var.business_owner_email

    SourceTool         = var.source_tool
  }
  tagging = merge(local.tags, var.additional_tags)

  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-external.html
  is_external_deployment = try(var.deployment_controller.type, null) == "EXTERNAL"
  is_daemon              = var.scheduling_strategy == "DAEMON"
  is_fargate             = var.launch_type == "FARGATE"

  #   Flattened `network_configuration`
  network_configuration = {
    assign_public_ip = var.assign_public_ip
    security_groups  = var.security_group_ids
    subnets          = var.subnet_ids
  }

}

# Fetch the current region
data "aws_region" "current" {}

resource "aws_ecs_cluster" "cluster" {
  count = var.create_ecs_cluster ? 1 : 0
  name  = "${local.name}-ecs-cluster"

  dynamic "setting" {
    for_each = var.settings
    content {
      name  = setting.value.name
      value = setting.value.value
    }
  }
  tags = local.tagging
}

resource "aws_ecs_task_definition" "task" {
  count                    = var.create_task_defination ? 1 : 0
  family                   = "${local.name}-ecs-task_def"
  network_mode             = var.network_mode
  requires_compatibilities = [var.launch_type] # In this case, FARGATE
  cpu                      = var.cpu           # Adjust CPU units as per your task requirement
  memory                   = var.memory        # Adjust memory units as per your task requirement
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = file("${path.root}/container_definitions.json")

  tags = local.tagging
}

resource "aws_ecs_service" "service" {
  name = "${local.name}-ecs-service"
  dynamic "capacity_provider_strategy" {
    # Set by task set if deployment controller is external
    for_each = { for k, v in var.capacity_provider_strategy : k => v if !local.is_external_deployment }

    content {
      base              = capacity_provider_strategy.value.base
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
    }
  }

  cluster = var.create_ecs_cluster ? "${aws_ecs_cluster.cluster[0].id}" : null

  dynamic "deployment_circuit_breaker" {
    for_each = var.deployment_circuit_breaker

    content {
      enable   = deployment_circuit_breaker.value.enable
      rollback = deployment_circuit_breaker.value.rollback
    }
  }

  dynamic "deployment_controller" {
    for_each = var.deployment_controller

    content {
      type = deployment_controller.value.type
    }
  }

  deployment_maximum_percent         = local.is_daemon || local.is_external_deployment ? null : var.deployment_maximum_percent
  deployment_minimum_healthy_percent = local.is_daemon || local.is_external_deployment ? null : var.deployment_minimum_healthy_percent
  desired_count                      = local.is_daemon || local.is_external_deployment ? null : var.desired_count
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  enable_execute_command             = var.enable_execute_command
  force_new_deployment               = local.is_external_deployment ? null : var.force_new_deployment
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  iam_role                           = var.iam_role_arn
  launch_type                        = local.is_external_deployment || length(var.capacity_provider_strategy) > 0 ? null : var.launch_type

  dynamic "load_balancer" {
    # Set by task set if deployment controller is external
    for_each = { for k, v in var.load_balancer : k => v if !local.is_external_deployment }

    content {
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
      target_group_arn = load_balancer.value.target_group_arn
    }
  }


  dynamic "network_configuration" {
    # Set by task set if deployment controller is external
    for_each = var.network_mode == "awsvpc" ? [{ for k, v in local.network_configuration : k => v if !local.is_external_deployment }] : []

    content {
      assign_public_ip = network_configuration.value.assign_public_ip
      security_groups  = network_configuration.value.security_groups
      subnets          = network_configuration.value.subnets
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy

    content {
      field = ordered_placement_strategy.value.field
      type  = ordered_placement_strategy.value.type
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints

    content {
      expression = placement_constraints.value.expression
      type       = placement_constraints.value.type
    }
  }

  # Set by task set if deployment controller is external
  platform_version    = local.is_fargate && !local.is_external_deployment ? var.platform_version : null
  scheduling_strategy = local.is_fargate ? "REPLICA" : var.scheduling_strategy


  task_definition       = var.create_task_defination ? "${aws_ecs_task_definition.task[0].arn}" : var.task_definition_arn
  triggers              = var.triggers
  wait_for_steady_state = var.wait_for_steady_state

  tags = local.tagging

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  lifecycle {
    ignore_changes = [
      desired_count, # Always ignored
      task_definition,
      load_balancer,
    ]
  }
}
