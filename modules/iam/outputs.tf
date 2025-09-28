output "github_oidc_role_arn" {
  value = aws_iam_role.github_oidc.arn
}
output "github_oidc_provider_arn" {
  value = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : var.existing_oidc_provider_arn
}
