# Multi-Cloud Infrastructure as Code

This repository contains Terraform configurations for deploying the Infracodebase application across multiple cloud providers (AWS, GCP, and Azure), along with comprehensive cost analysis and architecture diagrams.

## Architecture Overview

The infrastructure mirrors your existing Azure setup across different cloud providers:

- **AWS**: ECS Fargate + RDS PostgreSQL + Application Load Balancer
- **GCP**: Cloud Run + Cloud SQL + VPC Networking
- **Azure**: App Service + PostgreSQL + Application Gateway (current)

## Repository Structure

```
├── aws-infrastructure/          # AWS Terraform configuration
│   ├── main.tf                 # Core infrastructure resources
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   ├── providers.tf            # AWS provider configuration
│   ├── locals.tf               # Local values and calculations
│   └── README.md               # AWS-specific documentation
│
├── gcp-infrastructure/          # GCP Terraform configuration
│   ├── main.tf                 # Core infrastructure resources
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   ├── providers.tf            # GCP provider configuration
│   ├── locals.tf               # Local values and calculations
│   └── README.md               # GCP-specific documentation
│
├── azure-asset-inventory.json   # Current Azure resources inventory
├── azure-asset-inventory-report.md # Azure analysis report
├── infrastructure-cost-analysis.md # Detailed cost breakdown
└── terraform-validation-report.md  # Validation results
```

## Quick Start

### Prerequisites

- [Terraform](https://terraform.io) >= 1.0
- Cloud provider CLI tools configured
- Appropriate cloud credentials

### AWS Deployment

```bash
cd aws-infrastructure
terraform init
terraform plan
terraform apply
```

### GCP Deployment

```bash
cd gcp-infrastructure
terraform init
terraform plan -var="gcp_project_id=your-project-id"
terraform apply -var="gcp_project_id=your-project-id"
```

## Cost Analysis

| Provider | Development | Production | Annual (Dev) |
|----------|-------------|------------|--------------|
| **GCP** | $45/month | $186/month | $534/year |
| **AWS** | $113/month | $346/month | $1,356/year |
| **Azure** | $121/month | $280/month | $1,455/year |

**Key Finding**: GCP offers 61% cost savings vs AWS for development workloads.

See [infrastructure-cost-analysis.md](./infrastructure-cost-analysis.md) for detailed breakdown.

## Architecture Diagrams

Visual architecture diagrams are available in the repository:

- **AWS Infrastructure**: ECS Fargate, RDS, VPC with public/private subnets
- **GCP Infrastructure**: Cloud Run, Cloud SQL, VPC with private networking
- **Azure Infrastructure**: Current App Service setup with PostgreSQL

## Security Features

All configurations implement security best practices:

- **Network Isolation**: Private subnets/networks for databases
- **Encryption**: KMS/Cloud KMS encryption for all data at rest
- **Access Control**: Least-privilege IAM policies
- **Secrets Management**: Secure credential storage
- **SSL/TLS**: Enforced encryption in transit

## Validation Results

Both AWS and GCP configurations have been validated:

- **AWS**: 35 resources, fully validated and planned
- **GCP**: ~25 resources, validated with correct syntax

See [terraform-validation-report.md](./terraform-validation-report.md) for details.

## Migration Recommendations

### Development Workloads
**Recommended: GCP**
- 61% cost savings vs AWS
- Serverless architecture (Cloud Run)
- Pay-per-use pricing model

### Production Workloads
**Recommended: GCP**
- 46% cost savings vs AWS
- Auto-scaling capabilities
- Strong security and compliance

### Migration Strategy
1. **Phase 1**: Development environments to GCP
2. **Phase 2**: Optimize current Azure setup
3. **Phase 3**: Evaluate production migration

## Documentation

Detailed documentation is available in each directory:

- [AWS Infrastructure Guide](./aws-infrastructure/README.md)
- [GCP Infrastructure Guide](./gcp-infrastructure/README.md)
- [Cost Analysis Report](./infrastructure-cost-analysis.md)
- [Validation Report](./terraform-validation-report.md)

## Tools & Technologies

- **Infrastructure as Code**: Terraform
- **Cloud Providers**: AWS, Google Cloud Platform, Azure
- **Containerization**: Docker, ECS Fargate, Cloud Run
- **Databases**: RDS PostgreSQL, Cloud SQL PostgreSQL
- **Monitoring**: CloudWatch, Cloud Logging, Application Insights
- **Security**: KMS, Cloud KMS, Key Vault

## Support

For questions or issues:

1. Check the provider-specific README files
2. Review the validation and cost analysis reports
3. Consult the Terraform documentation for each cloud provider

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Generated with**: Terraform MCP Server + Claude Code
**Last Updated**: December 2024