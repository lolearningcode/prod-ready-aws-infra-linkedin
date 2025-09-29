output "alb_arn" {
  value = aws_lb.app.arn
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "alb_listener_arn" {
  value = (
    length(concat(
      aws_lb_listener.https[*].arn,
      aws_lb_listener.http_redirect[*].arn,
      aws_lb_listener.http_forward[*].arn
    )) > 0
  ) ? concat(
    aws_lb_listener.https[*].arn,
    aws_lb_listener.http_redirect[*].arn,
    aws_lb_listener.http_forward[*].arn
  )[0] : ""
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}
