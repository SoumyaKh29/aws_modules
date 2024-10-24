output "ecs_service_id" {
  value       = aws_ecs_service.service.id
  description = "ARN that identifies the service."
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster."
  value       = var.create_ecs_cluster ? "${aws_ecs_cluster.cluster[0].arn}" : ""
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  value       = var.create_ecs_cluster ? "${aws_ecs_cluster.cluster[0].name}" : ""
}

output "ecs_task_defination_arn" {
  description = "The ARN of the ECS task defination."
  value       = var.create_task_defination ? "${aws_ecs_task_definition.task[0].arn}" : ""
}
