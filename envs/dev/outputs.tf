output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_listener_arn" {
  value = module.alb.alb_listener_arn
}

output "alb_target_group_arn" {
  value = module.alb.target_group_arn
}

output "alb_security_group_id" {
  value = module.security_groups.alb_sg_id
}

output "ecs_security_group_id" {
  value = module.security_groups.ecs_sg_id
}

output "cloudwatch_log_group" {
  value = module.monitoring.log_group_name
}

output "sns_topic_arn" {
  value       = module.monitoring.sns_topic_arn
  description = "SNS topic for alerts (if created)"
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.ecs.ecs_service_name
}

output "ecs_task_definition" {
  value = module.ecs.ecs_task_definition
}

output "github_oidc_role_arn" {
  value = module.iam.github_oidc_role_arn
}

output "github_oidc_provider_arn" {
  value = module.iam.github_oidc_provider_arn
}
