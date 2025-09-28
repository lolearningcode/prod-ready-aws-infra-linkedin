output "alb_arn" {
  value = aws_lb.app.arn
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "alb_listener_arn" {
  value = length(aws_lb_listener.http_redirect) > 0 ? aws_lb_listener.http_redirect[0].arn : aws_lb_listener.http_forward[0].arn
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}