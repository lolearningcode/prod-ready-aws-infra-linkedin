resource "aws_lb" "app" {
  name                       = "${var.name}-alb"
  load_balancer_type         = "application"
  subnets                    = var.public_subnets
  security_groups            = [var.alb_sg_id]
  drop_invalid_header_fields = true
}

resource "aws_lb_target_group" "app" {
  name_prefix = "${var.name}-t-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http_redirect" {
  count             = var.enable_https && var.certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  # Redirect plain HTTP to HTTPS so traffic is protected
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "http_forward" {
  count             = var.enable_https && var.certificate_arn != "" ? 0 : 1
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  # Forward to target group when HTTPS is not enabled
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# HTTPS listener (created when enable_https = true)
resource "aws_lb_listener" "https" {
  count             = var.enable_https && var.certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy

  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
