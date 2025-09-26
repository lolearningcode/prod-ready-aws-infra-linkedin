terraform {
  backend "s3" {
    bucket       = "269599744150-terraform-state-dev"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "app_image" {
  description = "Container image URI supplied by CI (overridden with -var=app_image=...)"
  type        = string
  default     = ""
}

module "vpc" {
  source = "../../modules/vpc"
  name   = "dev"
}


module "security_groups" {
  source = "../../modules/security-groups"
  env    = "dev"
  vpc_id = module.vpc.vpc_id
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
  container_image  = var.app_image != "" ? var.app_image : "nginx:latest"
}

module "iam" {
  source      = "../../modules/iam"
  name        = "dev"
  github_repo = "lolearningcode/prod-ready-aws-infra"
}

module "monitoring" {
  source      = "../../modules/monitoring"
  name        = "dev"
  alarm_email = "cleointhecloud.1@gmail.com"
}
