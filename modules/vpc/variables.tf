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
