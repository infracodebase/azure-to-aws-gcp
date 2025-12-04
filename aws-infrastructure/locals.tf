locals {
  name_prefix = "${var.app_name}-${var.environment}"

  common_tags = {
    Environment = var.environment
    Creator     = "Terraform"
    App         = var.app_name
  }

  vpc_private_subnets = [
    cidrsubnet(var.vpc_cidr, 8, 1), # 10.0.1.0/24
    cidrsubnet(var.vpc_cidr, 8, 2)  # 10.0.2.0/24
  ]

  vpc_public_subnets = [
    cidrsubnet(var.vpc_cidr, 8, 101), # 10.0.101.0/24
    cidrsubnet(var.vpc_cidr, 8, 102)  # 10.0.102.0/24
  ]
}