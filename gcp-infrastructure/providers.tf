provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region

  default_labels = {
    environment = var.environment
    creator     = "terraform"
    app         = "infracodebase"
  }
}