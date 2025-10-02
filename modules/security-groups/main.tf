// tfsec:ignore:aws-ec2-no-public-egress-sgr ALB egress uses module variable `egress_cidr_blocks`. Default is VPC-only; in dev this may be set to allow broader egress for image pulls/testing.
resource "aws_security_group" "alb" {
  name        = "${var.env}-alb-sg"
  description = "Allow inbound HTTP/HTTPS"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ingress_cidr_blocks
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.alb_ingress_cidr_blocks
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.effective_egress_cidrs
  }
}

// tfsec:ignore:aws-ec2-no-public-egress-sgr ECS task egress uses module variable `egress_cidr_blocks`. Default is VPC-only; in dev this may be set to allow broader egress for image pulls/testing.
resource "aws_security_group" "ecs" {
  name        = "${var.env}-ecs-sg"
  description = "Allow ECS tasks to receive traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.effective_egress_cidrs
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

locals {
  # If the caller supplies explicit egress CIDRs use them, otherwise
  # restrict egress to the VPC CIDR by default (safer than 0.0.0.0/0).
  effective_egress_cidrs = length(var.egress_cidr_blocks) > 0 ? var.egress_cidr_blocks : [data.aws_vpc.selected.cidr_block]
}
