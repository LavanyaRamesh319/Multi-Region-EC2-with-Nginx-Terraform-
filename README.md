# Multi-Region EC2 with Nginx (Terraform)

This project demonstrates how to use **Terraform** to provision EC2 instances in multiple AWS regions and automatically configure them with **Nginx**.  
It’s a practical example of Infrastructure-as-Code for cloud automation.

---

## 📦 Features
- Deploys **two EC2 instances**:
  - One in `us-east-1`
  - One in `eu-central-1`
- Installs and starts **Nginx web server** via `user_data`
- Configures **security groups** to allow inbound HTTP (port 80)
---

## 🚀 Prerequisites
- AWS account with IAM user & access keys
- AWS CLI configured (`aws configure`)
- Terraform installed (v1.x recommended)

---

## ⚙️ Usage
Initialize and apply the configuration:
```bash
terraform init
terraform apply
