terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket  = "269599744150-terraform-state-dev"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
  name   = "dev"
}


module "security_groups" {
  source = "../../modules/security-groups"
  env    = "dev"
  vpc_id = module.vpc.vpc_id
  # For development, keep ALB closed by default. Provide your office or VPN CIDRs
  # to allow access (example below). Avoid using 0.0.0.0/0 in production.
  alb_ingress_cidr_blocks = []
  egress_cidr_blocks      = ["0.0.0.0/0"]
}

module "alb" {
  source         = "../../modules/alb"
  name           = "dev"
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.security_groups.alb_sg_id
  vpc_id         = module.vpc.vpc_id
}

module "ecs" {
  source           = "../../modules/ecs"
  name             = "dev"
  private_subnets  = module.vpc.private_subnets
  app_sg_id        = module.security_groups.ecs_sg_id
  target_group_arn = module.alb.target_group_arn
  container_image  = var.app_image
}

module "iam" {
  source                     = "../../modules/iam"
  name                       = "dev"
  github_repo                = "lolearningcode/prod-ready-aws-infra"
  create_oidc_provider       = false
  existing_oidc_provider_arn = "arn:aws:iam::269599744150:oidc-provider/token.actions.githubusercontent.com"
}

module "monitoring" {
  source               = "../../modules/monitoring"
  name                 = "dev"
  alarm_email          = "cleointhecloud.1@gmail.com"
  create_sns_topic     = false
  manage_log_retention = false
}
