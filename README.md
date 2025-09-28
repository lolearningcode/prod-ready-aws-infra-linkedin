# 🚀 Prod-Ready AWS Infrastructure with Terraform

This project provisions a **production-ready AWS environment** using Terraform.  
It’s designed to be simple enough for learning, but structured the way real teams deploy to production.  

✅ VPC with public + private subnets  
✅ ECS Fargate cluster with sample app (nginx)  
✅ Application Load Balancer (ALB) with HTTPS  
✅ IAM GitHub OIDC role (no static AWS creds)  
✅ Remote state in S3 with DynamoDB locking  
✅ CloudWatch logging, metrics, and alarms  
✅ Optional SNS email alerts for incidents  

---

## 📊 Architecture

![Architecture](./diagrams/architecture.png)

*(Replace this placeholder with your diagram — e.g., VPC → ALB → ECS → CloudWatch/SNS)*

---

## 📂 Repo Structure

```
.
├── app/                     # Node.js app source (Dockerized)
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
├── diagrams/                # Architecture diagrams
├── envs/                    # Environment configs (dev, prod)
│   ├── dev/
│   │   └── main.tf
│   └── prod/
│       └── main.tf
├── modules/                 # Terraform modules
│   ├── alb/
│   ├── ecs/
│   ├── iam/
│   ├── monitoring/
│   ├── security-groups/
│   └── vpc/
├── .github/workflows/       # CI/CD pipelines (Terraform + ECS deploy)
│   ├── ci-cd.yml
│   └── terraform.yml
├── .gitignore
├── LICENSE
├── README.md
```

---

## ⚙️ CI/CD

This project uses GitHub Actions for automation:
- **terraform.yml**: Runs Terraform init/plan/apply with OIDC authentication to AWS.
- **ci-cd.yml**: Builds and pushes the app Docker image to ECR, then triggers ECS service update.

---

## ALB HTTPS listener note

The `modules/alb` module now creates an HTTPS listener (port 443) when `enable_https` is true (default).
To attach a TLS certificate, pass the `certificate_arn` variable to the module. If `certificate_arn` is empty the
HTTPS listener will still be created but no certificate will be attached.

Example:

```
module "alb" {
	source          = "./modules/alb"
	name            = "myapp"
	public_subnets  = var.public_subnets
	alb_sg_id       = aws_security_group.alb.id
	vpc_id          = var.vpc_id
	certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

The module also redirects incoming HTTP (port 80) traffic to HTTPS (port 443) to satisfy security scanners like tfsec.

## Security group CIDR configuration

The `security-groups` module used by this repo no longer hard-codes public CIDRs. Instead it exposes the variable `alb_ingress_cidr_blocks` which controls which client CIDRs are allowed to reach the ALB on ports 80/443.

- Default behavior: empty list (deny all). This prevents accidental public exposure.
- For development, you can pass your office/VPN CIDR(s) or your current IP range. Example:

```hcl
module "security_groups" {
  source = "../../modules/security-groups"
  env    = "dev"
  vpc_id = module.vpc.vpc_id
  alb_ingress_cidr_blocks = ["203.0.113.0/24"] # replace with your allowed CIDRs
}
```

Avoid using `["0.0.0.0/0"]` unless you intentionally want the ALB publicly accessible.