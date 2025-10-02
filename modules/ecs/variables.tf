variable "name" {
  description = "Name prefix for ECS resources"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "app_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for ECS service"
  type        = string
}

variable "container_image" {
  description = "Container image URI for the app (must be provided, typically from ECR)"
  type        = string
}
