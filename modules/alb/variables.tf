variable "name" {
  description = "Name prefix for ALB resources"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "certificate_arn" {
  description = "(Optional) ARN of the TLS certificate to attach to the HTTPS listener. If empty, no certificate will be attached."
  type        = string
  default     = ""
}

variable "enable_https" {
  description = "Whether to create an HTTPS listener and redirect HTTP to HTTPS"
  type        = bool
  default     = true
}

variable "ssl_policy" {
  description = "Optional SSL policy for the HTTPS listener, for example 'ELBSecurityPolicy-2016-08'"
  type        = string
  default     = null
}

variable "allow_http" {
  description = "Whether plain HTTP (port 80) should be allowed to forward to targets. Defaults to false to encourage HTTPS."
  type        = bool
  default     = false
}

variable "allow_public_alb" {
  description = "Whether the ALB should be publicly accessible. Defaults to false (ALB is internal). Set to true to allow public ALB for demo/testing."
  type        = bool
  default     = false
}
