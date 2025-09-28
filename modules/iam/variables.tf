variable "name" {
  description = "Name prefix for IAM resources"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in the format owner/repo"
  type        = string
}

variable "create_oidc_provider" {
  description = "Whether to create the GitHub OIDC provider in this account"
  type        = bool
  default     = true
}

variable "existing_oidc_provider_arn" {
  description = "If not creating the OIDC provider, provide its ARN"
  type        = string
  default     = ""
}
