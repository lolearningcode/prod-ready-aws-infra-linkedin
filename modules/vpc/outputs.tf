output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "vpce_security_group_id" {
  description = "Effective VPC endpoint security group id (either provided or created)"
  value       = var.vpce_security_group_id != "" ? var.vpce_security_group_id : (var.create_endpoints ? aws_security_group.vpce[0].id : "")
}