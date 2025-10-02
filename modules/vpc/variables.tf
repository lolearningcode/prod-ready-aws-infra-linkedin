variable "name" {
  description = "Name prefix for VPC resources"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "map_public_ip_on_launch" {
  description = "Whether public subnets should map public IPs on launch"
  type        = bool
  default     = false
}

variable "create_endpoints" {
  description = "Whether to create VPC endpoints for S3 and ECR so private resources can access them without internet egress"
  type        = bool
  default     = false
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT gateway to allow private subnets outbound internet access"
  type        = bool
  default     = false
}
