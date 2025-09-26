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