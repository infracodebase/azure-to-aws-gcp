locals {
  name_prefix = "${var.app_name}-${var.environment}"

  common_labels = {
    environment = var.environment
    creator     = "terraform"
    app         = var.app_name
  }

  # Service APIs to enable
  services = [
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "run.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}