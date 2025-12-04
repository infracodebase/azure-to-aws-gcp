# Azure Asset Inventory Report

**Subscription:** development (3a083da7-77cd-484f-b1fa-cbd058e12c42)
**Generated:** $(date)
**Total Resources:** 14

## Executive Summary

This Azure subscription contains **14 resources** across **4 resource groups** in **3 regions**:
- East US (6 resources)
- East US 2 (7 resources)
- United States (1 resource)

### Resource Distribution by Service Type

| Service Type | Count | Description |
|--------------|-------|-------------|
| Storage Accounts | 2 | Blob storage for applications |
| Key Vaults | 2 | Secrets and certificate management |
| Web Apps | 1 | Application hosting |
| App Service Plans | 1 | Compute resources for web apps |
| PostgreSQL Servers | 1 | Managed database service |
| Log Analytics Workspaces | 2 | Monitoring and logging |
| Application Insights | 1 | Application performance monitoring |
| B2C Directories | 2 | Identity and access management |
| SSL Certificates | 1 | Security certificates |
| Smart Detector Rules | 1 | Automated alerting |

## Resource Groups Overview

### 1. rg-use-shared-dev (East US)
**Purpose:** Shared development resources
**Resources:** 2
- **kv-use-shared-dev** - Key Vault for shared secrets
- **stouseshareddev** - Storage Account (Standard_LRS)

### 2. rg-dx-b2c-use-dev (United States)
**Purpose:** B2C identity services
**Resources:** 1
- **onwardplatformsb2c.onmicrosoft.com** - Azure AD B2C Directory (Premium P1)

### 3. rg-use2-infracodebase-dev (East US 2)
**Purpose:** Infracodebase application stack
**Resources:** 10
- **app-infracodebase-use2-dev** - Web App (Linux container)
- **asp-use2-infracodebase-dev** - App Service Plan (B2 Linux)
- **psqlflxsvr-use2-infracodebase-dev** - PostgreSQL Flexible Server (Standard_B1ms)
- **stouse2icbdev** - Storage Account (Standard_LRS)
- **kv-use2-icb-dev** - Key Vault for app secrets
- **log-use2-infracodebase-dev** - Log Analytics Workspace
- **appi-use2-infracodebase-dev** - Application Insights (Node.JS)
- **dev.infracodebase.com** - SSL Certificate
- **Failure Anomalies Rule** - Smart detector for anomaly detection

### 4. DefaultResourceGroup-EUS (East US)
**Purpose:** Default Azure resources
**Resources:** 2
- **DefaultWorkspace-[GUID]-EUS** - Default Log Analytics Workspace
- **infracodebase.onmicrosoft.com** - Azure AD B2C Directory (Premium P1)

## Infrastructure Patterns & Governance

### Tagging Strategy
**Well-Tagged Resources (Terraform-managed):**
- App: "Infracodebase"
- Creator: "Terraform"
- Environment: "Development"

**Inconsistent Tagging:**
- Some shared resources only have "Environment: Development"
- Default Azure resources have no tags
- B2C directories lack consistent tagging

### Infrastructure as Code Usage
- **Terraform-managed resources:** 7 resources in rg-use2-infracodebase-dev
- **Manually created:** Resources in other resource groups
- **Recommendation:** Migrate all resources to Terraform for consistency

### Security & Compliance
- **Key Vaults:** 2 vaults properly deployed for secrets management
- **SSL Certificates:** Custom domain certificate in place
- **Monitoring:** Application Insights and Log Analytics configured
- **Database:** PostgreSQL with flexible server model

### Cost Optimization Opportunities
- **Storage:** Both accounts using Standard_LRS (cost-optimized)
- **Compute:** B2 App Service Plan (development appropriate)
- **Database:** Standard_B1ms (development tier)

## Recommendations

1. **Standardize Tagging:** Apply consistent tags across all resource groups
2. **Infrastructure as Code:** Migrate manually created resources to Terraform
3. **Resource Naming:** Ensure consistent naming conventions across environments
4. **Monitoring:** Extend Application Insights coverage to all applications
5. **Security:** Regular Key Vault access reviews and secret rotation

## Detailed Resource Inventory

| Name | Resource Group | Type | Location | SKU | Tags |
|------|----------------|------|----------|-----|------|
| kv-use-shared-dev | rg-use-shared-dev | Key Vault | East US | - | Environment: Development |
| stouseshareddev | rg-use-shared-dev | Storage Account | East US | Standard_LRS | Environment: Development |
| onwardplatformsb2c.onmicrosoft.com | rg-dx-b2c-use-dev | B2C Directory | United States | Premium P1 | None |
| DefaultWorkspace-[...] | DefaultResourceGroup-EUS | Log Analytics | East US | - | None |
| infracodebase.onmicrosoft.com | DefaultResourceGroup-EUS | B2C Directory | United States | Premium P1 | None |
| stouse2icbdev | rg-use2-infracodebase-dev | Storage Account | East US 2 | Standard_LRS | App, Creator, Environment |
| asp-use2-infracodebase-dev | rg-use2-infracodebase-dev | App Service Plan | East US 2 | B2 | App, Creator, Environment |
| psqlflxsvr-use2-infracodebase-dev | rg-use2-infracodebase-dev | PostgreSQL | East US 2 | Standard_B1ms | App, Creator, Environment |
| kv-use2-icb-dev | rg-use2-infracodebase-dev | Key Vault | East US 2 | - | App, Creator, Environment |
| log-use2-infracodebase-dev | rg-use2-infracodebase-dev | Log Analytics | East US 2 | - | App, Creator, Environment |
| appi-use2-infracodebase-dev | rg-use2-infracodebase-dev | Application Insights | East US 2 | - | App, Creator, Environment |
| app-infracodebase-use2-dev | rg-use2-infracodebase-dev | Web App | East US 2 | - | App, Creator, Environment |
| dev.infracodebase.com | rg-use2-infracodebase-dev | SSL Certificate | East US 2 | - | None |
| Failure Anomalies - appi-use2-infracodebase-dev | rg-use2-infracodebase-dev | Smart Detector | Global | - | None |