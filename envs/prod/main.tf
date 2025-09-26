terraform {
  backend "s3" {
    bucket       = "269599744150-terraform-state-prod"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"
  name   = "prod"
}


module "security_groups" {
  source = "../../modules/security-groups"
  env    = "prod"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source         = "../../modules/alb"
  name           = "prod"
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.security_groups.alb_sg_id
  vpc_id         = module.vpc.vpc_id
}

module "ecs" {
  source           = "../../modules/ecs"
  name             = "prod"
  private_subnets  = module.vpc.private_subnets
  app_sg_id        = module.security_groups.ecs_sg_id
  target_group_arn = module.alb.target_group_arn
}

module "iam" {
  source      = "../../modules/iam"
  name        = "prod"
  github_repo = "lolearningcode/prod-ready-aws-infra"
}

module "monitoring" {
  source      = "../../modules/monitoring"
  name        = "prod"
  alarm_email = "cleointhecloud.1@gmail.com"
}
