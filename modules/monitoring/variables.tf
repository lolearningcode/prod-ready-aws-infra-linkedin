variable "name" {
  description = "Name prefix for monitoring resources"
  type        = string
}

variable "alarm_sns_topic" {
  description = "SNS topic ARN for CloudWatch alarms"
  type        = string
  default     = ""
}

variable "alarm_email" {
  description = "Email address for SNS alerts (leave empty to disable)"
  type        = string
  default     = ""
}
