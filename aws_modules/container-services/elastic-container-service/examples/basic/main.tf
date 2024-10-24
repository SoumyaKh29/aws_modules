module "ecs_service" {
  source = "../../"
  # Below values specify Tags
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
  create_ecs_cluster   = true
  settings = {
    container_insights = {
      name  = "containerInsights"
      value = "enabled"
    }
  }
  create_task_defination = true
  cpu                    = 1024
  memory                 = 3072
  network_mode           = "awsvpc"
  scheduling_strategy    = "REPLICA"
  launch_type            = "FARGATE"
  deployment_controller = {
    controller = {
      type = "ECS"
    }
  }
  desired_count      = 2
  assign_public_ip   = true
  security_group_ids = ["sg-234dxzx345tgvsdc"]
  subnet_ids         = ["subnet-w234erfe5677786", "subnet-345tgfds34567uygc"]
}
