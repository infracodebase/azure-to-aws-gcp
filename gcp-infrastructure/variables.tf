variable "gcp_project_id" {
  type        = string
  description = "GCP project ID"
}

variable "gcp_region" {
  type        = string
  description = "GCP region for resources"
  default     = "us-east1"
}

variable "gcp_zone" {
  type        = string
  description = "GCP zone for resources"
  default     = "us-east1-b"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "app_name" {
  type        = string
  description = "Application name"
  default     = "infracodebase"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "database_name" {
  type        = string
  description = "PostgreSQL database name"
  default     = "infracodebase"
}

variable "database_username" {
  type        = string
  description = "PostgreSQL database username"
  default     = "postgres"
}

variable "container_image" {
  type        = string
  description = "Container image for the application"
  default     = "gcr.io/cloudrun/hello"
}

variable "domain_name" {
  type        = string
  description = "Custom domain name for the application"
  default     = "dev.infracodebase.com"
}

variable "database_tier" {
  type        = string
  description = "Cloud SQL instance tier"
  default     = "db-f1-micro"
}