variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
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

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
  default     = ["us-east-1a", "us-east-1b"]
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
  default     = "nginx:latest"
}

variable "domain_name" {
  type        = string
  description = "Custom domain name for the application"
  default     = "dev.infracodebase.com"
}