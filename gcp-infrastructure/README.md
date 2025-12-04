# GCP Infrastructure for Infracodebase

This Terraform configuration creates a production-ready GCP infrastructure that mirrors the Azure setup, featuring:

## Architecture Overview

- **Cloud Run** for serverless containerized application hosting
- **Cloud SQL PostgreSQL** for managed database services
- **Cloud Storage** for object storage
- **Cloud Logging** for centralized logging
- **Cloud KMS** for encryption key management
- **VPC** with private networking and VPC Access Connector

## Services Deployed

| Service | Purpose | Configuration |
|---------|---------|---------------|
| VPC Network | Network isolation | Custom VPC with public/private subnets |
| Cloud Run | Container hosting | 1 CPU, 512MB memory, auto-scaling |
| Cloud SQL PostgreSQL | Database | db-f1-micro, encrypted, private IP |
| Cloud Storage | Object storage | Regional bucket with KMS encryption |
| VPC Access Connector | Private connectivity | Connects Cloud Run to VPC |
| Cloud KMS | Encryption | Customer-managed encryption keys |
| Secret Manager | Secret storage | Database credentials management |

## Prerequisites

1. **Google Cloud SDK** installed and authenticated
2. **Terraform** >= 1.0 installed
3. **GCP Project** with billing enabled
4. **Required APIs** enabled (handled automatically by Terraform)

## Deployment Instructions

### 1. Clone and Navigate
```bash
cd gcp-infrastructure
```

### 2. Set Project ID
```bash
export TF_VAR_gcp_project_id="your-project-id"
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan Deployment
```bash
terraform plan
```

### 5. Deploy Infrastructure
```bash
terraform apply
```

### 6. Get Outputs
```bash
terraform output
```

## Configuration Variables

Create a `terraform.tfvars` file:

```hcl
gcp_project_id = "your-project-id"
gcp_region = "us-east1"
gcp_zone = "us-east1-b"
environment = "dev"
app_name = "infracodebase"
vpc_cidr = "10.0.0.0/16"
database_name = "infracodebase"
database_username = "postgres"
database_tier = "db-f1-micro"
container_image = "gcr.io/your-project/your-app:latest"
domain_name = "dev.infracodebase.com"
```

## Security Features

- **Private Networking**: Cloud SQL with private IP only
- **VPC Access Connector**: Secure connection between Cloud Run and VPC
- **KMS Encryption**: Customer-managed keys for all data at rest
- **Secret Manager**: Secure credential storage and access
- **IAM**: Service accounts with minimal required permissions
- **SSL/TLS**: HTTPS enforced for all external traffic

## APIs Enabled Automatically

The following Google Cloud APIs are enabled automatically:

- Compute Engine API
- Cloud SQL Admin API
- Cloud Run API
- Cloud Resource Manager API
- Cloud Logging API
- Cloud Monitoring API
- Cloud Storage API
- Secret Manager API
- Service Networking API

## Monitoring and Logging

- **Cloud Logging**: Centralized application and infrastructure logs
- **Cloud Run Metrics**: Built-in request/response monitoring
- **Log Storage**: Application logs stored in Cloud Storage
- **VPC Flow Logs**: Network traffic monitoring enabled

## Cost Optimization

- **Cloud Run**: Serverless, pay-per-request pricing
- **Cloud SQL**: f1-micro instance for development workloads
- **Cloud Storage**: Regional storage with versioning
- **Preemptible Resources**: Where applicable for cost savings

## Networking Architecture

```
Internet → Cloud Run → VPC Access Connector → VPC Network
                                              ├── Private Subnet (Cloud SQL)
                                              └── Cloud NAT (outbound traffic)
```

## Outputs

Key outputs available after deployment:

- `cloud_run_service_url`: Application endpoint URL
- `database_connection_name`: Cloud SQL connection string
- `storage_bucket_name`: GCS bucket name
- `vpc_network_name`: VPC network name
- `service_account_email`: Cloud Run service account

## Domain Configuration

To use a custom domain:

1. **Verify Domain**: Add domain to Google Search Console
2. **Map Domain**: Use `gcloud run domain-mappings create`
3. **Configure DNS**: Point domain to Cloud Run service URL

## Next Steps

1. **Custom Domain**: Configure domain mapping for Cloud Run
2. **SSL Certificate**: Configure managed SSL certificates
3. **Monitoring**: Set up Cloud Monitoring dashboards
4. **Backup**: Configure automated Cloud SQL backups
5. **CI/CD**: Integrate with Cloud Build or GitHub Actions

## Clean Up

To destroy the infrastructure:

```bash
terraform destroy
```

**Warning**: This will permanently delete all resources and data.

## Troubleshooting

### Common Issues

1. **API Not Enabled**: Wait for APIs to fully enable (can take 2-3 minutes)
2. **Quota Limits**: Check project quotas in Google Cloud Console
3. **Permissions**: Ensure service account has necessary IAM roles
4. **VPC Connector**: Connector creation can take 5-10 minutes

### Useful Commands

```bash
# Check Cloud Run service status
gcloud run services list

# View Cloud SQL instances
gcloud sql instances list

# Check VPC networks
gcloud compute networks list

# View service account keys
gcloud iam service-accounts keys list --iam-account=SERVICE_ACCOUNT_EMAIL
```