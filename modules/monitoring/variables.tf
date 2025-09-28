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

variable "create_sns_topic" {
  description = "Whether the module should create an SNS topic when alarm_email is provided"
  type        = bool
  default     = true
}

variable "manage_log_retention" {
  description = "Whether to set CloudWatch Logs retention via Terraform (true by default)"
  type        = bool
  default     = true
}
