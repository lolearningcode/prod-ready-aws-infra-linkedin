variable "alb_ingress_cidr_blocks" {
  description = "List of CIDR blocks allowed to reach the ALB on HTTP/HTTPS. Default is empty (deny all). Pass public CIDRs only if intentionally required. Example: [\"203.0.113.0/24\"] for office IP range or [\"0.0.0.0/0\"] if global access is required]."
  type        = list(string)
  default     = []
}

variable "egress_cidr_blocks" {
  description = "List of CIDR blocks for egress rules. When empty (default) egress is restricted to the VPC CIDR. Provide explicit public CIDRs only if you intentionally require broader outbound access."
  type        = list(string)
  default     = []
}
variable "env" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach SGs"
  type        = string
}
