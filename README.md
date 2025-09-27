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