output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}

output "cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "sns_topic_arn" {
  value       = var.alarm_email != "" ? aws_sns_topic.alerts[0].arn : null
  description = "SNS topic ARN for CloudWatch alarms (null if disabled)"
}