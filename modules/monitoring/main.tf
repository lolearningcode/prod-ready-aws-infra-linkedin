resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.name}-logs"
  retention_in_days = 14
}

# Optional SNS topic
# Create SNS topic only if no external topic ARN provided and alarm_email set
resource "aws_sns_topic" "alerts" {
  count = var.alarm_sns_topic == "" && var.alarm_email != "" ? 1 : 0
  name  = "${var.name}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alarm_sns_topic == "" && var.alarm_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts[0].arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  alarm_actions = var.alarm_sns_topic != "" ? [var.alarm_sns_topic] : (var.alarm_email != "" ? [aws_sns_topic.alerts[0].arn] : [])
}
