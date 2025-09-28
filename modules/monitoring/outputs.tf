output "log_group_name" {
  value = var.manage_log_retention ? aws_cloudwatch_log_group.ecs_with_retention[0].name : aws_cloudwatch_log_group.ecs_no_retention[0].name
}

output "cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "sns_topic_arn" {
  value       = var.create_sns_topic && var.alarm_email != "" ? aws_sns_topic.alerts[0].arn : null
  description = "SNS topic ARN for CloudWatch alarms (null if disabled or not created)"
}
