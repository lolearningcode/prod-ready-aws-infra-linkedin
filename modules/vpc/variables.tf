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

variable "vpce_security_group_id" {
  description = "Optional existing security group id to attach to interface VPC endpoints (e.g. ECR). If empty, the module will create one when endpoints are enabled."
  type        = string
  default     = ""
}

variable "vpce_allowed_source_security_group_ids" {
  description = "Optional list of security group ids which should be allowed to reach the interface VPC endpoints (source SGs). When provided the module will create SG rules allowing those SGs to talk to the endpoints on 443. This only applies when the module creates the vpce SG (i.e. vpce_security_group_id is empty)."
  type        = list(string)
  default     = []
}
