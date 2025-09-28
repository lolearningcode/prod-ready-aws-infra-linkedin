variable "container_image" {
  description = "Container image URI supplied by CI (overridden with -var=container_image=...)"
  type        = string
  default     = ""
}

variable "create_oidc_provider" {
  description = "Whether to create the GitHub OIDC provider in this account (root-level passthrough)"
  type        = bool
  default     = false
}

variable "existing_oidc_provider_arn" {
  description = "If not creating the OIDC provider, provide its ARN (root-level passthrough)"
  type        = string
  default     = ""
}

variable "create_sns_topic" {
  description = "Whether the monitoring module should create an SNS topic (root-level passthrough)"
  type        = bool
  default     = false
}

variable "manage_log_retention" {
  description = "Whether the monitoring module should manage log group retention (root-level passthrough)"
  type        = bool
  default     = false
}
