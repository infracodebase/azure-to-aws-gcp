output "project_id" {
  description = "GCP project ID"
  value       = var.gcp_project_id
}

output "vpc_network_name" {
  description = "VPC network name"
  value       = module.vpc.network_name
}

output "vpc_network_id" {
  description = "VPC network ID"
  value       = module.vpc.network_id
}

output "private_subnet_names" {
  description = "Private subnet names"
  value       = module.vpc.subnets_names
}

output "private_subnet_ips" {
  description = "Private subnet IP ranges"
  value       = module.vpc.subnets_ips
}

output "cloud_run_service_url" {
  description = "Cloud Run service URL"
  value       = module.cloud_run.service_url
}

output "cloud_run_service_name" {
  description = "Cloud Run service name"
  value       = module.cloud_run.service_name
}

output "database_instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.postgresql.name
}

output "database_connection_name" {
  description = "Cloud SQL connection name"
  value       = google_sql_database_instance.postgresql.connection_name
}

output "database_private_ip" {
  description = "Cloud SQL private IP address"
  value       = google_sql_database_instance.postgresql.private_ip_address
  sensitive   = true
}

output "storage_bucket_name" {
  description = "Cloud Storage bucket name"
  value       = google_storage_bucket.main.name
}

output "storage_bucket_url" {
  description = "Cloud Storage bucket URL"
  value       = google_storage_bucket.main.url
}

output "kms_key_ring_name" {
  description = "KMS key ring name"
  value       = google_kms_key_ring.main.name
}

output "kms_crypto_key_name" {
  description = "KMS crypto key name"
  value       = google_kms_crypto_key.main.name
}

output "service_account_email" {
  description = "Cloud Run service account email"
  value       = google_service_account.cloud_run.email
}

output "vpc_connector_name" {
  description = "VPC Access Connector name"
  value       = google_vpc_access_connector.connector.name
}

output "secret_manager_secret_name" {
  description = "Secret Manager secret name for database password"
  value       = google_secret_manager_secret.database_password.secret_id
}