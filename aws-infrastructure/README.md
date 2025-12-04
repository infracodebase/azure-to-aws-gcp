# AWS Infrastructure for Infracodebase

This Terraform configuration creates a production-ready AWS infrastructure that mirrors the Azure setup, featuring:

## Architecture Overview

- **ECS Fargate** for containerized application hosting
- **Application Load Balancer** for HTTP/HTTPS traffic distribution
- **RDS PostgreSQL** for managed database services
- **S3** for object storage
- **CloudWatch** for monitoring and logging
- **KMS** for encryption at rest
- **VPC** with public/private subnets across multiple AZs

## Services Deployed

| Service | Purpose | Configuration |
|---------|---------|---------------|
| VPC | Network isolation | 10.0.0.0/16 with public/private subnets |
| ECS Fargate | Container hosting | 256 CPU, 512MB memory |
| RDS PostgreSQL | Database | db.t3.micro, encrypted storage |
| Application Load Balancer | Load balancing | HTTP/HTTPS termination |
| S3 | Object storage | Versioned, encrypted with KMS |
| CloudWatch Logs | Application logging | 7-day retention |
| KMS | Encryption | Customer-managed key |

## Prerequisites

1. **AWS CLI** configured with appropriate credentials
2. **Terraform** >= 1.0 installed
3. **AWS Account** with necessary permissions

## Deployment Instructions

### 1. Clone and Navigate
```bash
cd aws-infrastructure
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Plan Deployment
```bash
terraform plan -var="gcp_project_id=your-project-id"
```

### 4. Deploy Infrastructure
```bash
terraform apply -var="gcp_project_id=your-project-id"
```

### 5. Get Outputs
```bash
terraform output
```

## Configuration Variables

Create a `terraform.tfvars` file:

```hcl
aws_region = "us-east-1"
environment = "dev"
app_name = "infracodebase"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
database_name = "infracodebase"
database_username = "postgres"
container_image = "your-app-image:latest"
domain_name = "dev.infracodebase.com"
```

## Security Features

- **Network Isolation**: Private subnets for application and database
- **Encryption**: KMS encryption for RDS, S3, and CloudWatch Logs
- **IAM**: Least-privilege service roles and policies
- **Security Groups**: Restrictive ingress/egress rules
- **SSL/TLS**: HTTPS termination at load balancer level

## Monitoring and Logging

- **CloudWatch Logs**: Application logs with 7-day retention
- **Container Insights**: ECS cluster monitoring enabled
- **Health Checks**: Load balancer health checks configured
- **KMS Logging**: Encryption key usage tracked

## Cost Optimization

- **Fargate**: Pay-per-use serverless containers
- **RDS**: t3.micro instance for development
- **S3**: Standard storage with lifecycle policies
- **CloudWatch**: 7-day log retention to minimize costs

## Outputs

Key outputs available after deployment:

- `load_balancer_dns`: Application endpoint URL
- `database_endpoint`: PostgreSQL connection string (sensitive)
- `s3_bucket_name`: Storage bucket name
- `vpc_id`: VPC identifier
- `ecs_cluster_id`: ECS cluster identifier

## Next Steps

1. **Custom Domain**: Configure Route 53 for custom domain
2. **SSL Certificate**: Request ACM certificate for HTTPS
3. **Monitoring**: Set up CloudWatch dashboards and alarms
4. **Backup**: Configure automated RDS backups
5. **CI/CD**: Integrate with CodePipeline or GitHub Actions

## Clean Up

To destroy the infrastructure:

```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete all resources and data.