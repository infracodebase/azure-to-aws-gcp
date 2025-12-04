# Enable required APIs
resource "google_project_service" "services" {
  for_each = toset(local.services)

  service = each.value

  disable_dependent_services = true
  disable_on_destroy         = false
}

# VPC Network using Google's official module
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 13.0"

  project_id   = var.gcp_project_id
  network_name = "${local.name_prefix}-vpc"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${local.name_prefix}-private-subnet"
      subnet_ip             = "10.0.1.0/24"
      subnet_region         = var.gcp_region
      subnet_private_access = true
      subnet_flow_logs      = true
      description          = "Private subnet for applications"
    },
    {
      subnet_name           = "${local.name_prefix}-public-subnet"
      subnet_ip             = "10.0.101.0/24"
      subnet_region         = var.gcp_region
      subnet_private_access = false
      subnet_flow_logs      = true
      description          = "Public subnet for load balancers"
    }
  ]

  secondary_ranges = {
    "${local.name_prefix}-private-subnet" = [
      {
        range_name    = "${local.name_prefix}-pods"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "${local.name_prefix}-services"
        ip_cidr_range = "192.168.64.0/18"
      }
    ]
  }

  depends_on = [google_project_service.services]
}

# Cloud NAT for private subnet internet access
resource "google_compute_router" "router" {
  name    = "${local.name_prefix}-router"
  region  = var.gcp_region
  network = module.vpc.network_id

  bgp {
    asn = 64514
  }

  depends_on = [google_project_service.services]
}

resource "google_compute_router_nat" "nat" {
  name                               = "${local.name_prefix}-nat"
  router                             = google_compute_router.router.name
  region                             = var.gcp_region
  nat_ip_allocate_option            = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall rules
resource "google_compute_firewall" "allow_http_https" {
  name    = "${local.name_prefix}-allow-http-https"
  network = module.vpc.network_name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]

  depends_on = [google_project_service.services]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${local.name_prefix}-allow-internal"
  network = module.vpc.network_name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16", "192.168.0.0/16"]

  depends_on = [google_project_service.services]
}

# Cloud Storage bucket
resource "google_storage_bucket" "main" {
  name          = "${local.name_prefix}-storage-${random_string.bucket_suffix.result}"
  location      = var.gcp_region
  force_destroy = true

  versioning {
    enabled = true
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.main.id
  }

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  labels = local.common_labels

  depends_on = [google_project_service.services]
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# KMS key for encryption
resource "google_kms_key_ring" "main" {
  name     = "${local.name_prefix}-keyring"
  location = var.gcp_region

  depends_on = [google_project_service.services]
}

resource "google_kms_crypto_key" "main" {
  name            = "${local.name_prefix}-key"
  key_ring        = google_kms_key_ring.main.id
  rotation_period = "7776000s" # 90 days

  labels = local.common_labels
}

# Random password for database
resource "random_password" "database_password" {
  length  = 32
  special = true
}

# Secret Manager for database password
resource "google_secret_manager_secret" "database_password" {
  secret_id = "${local.name_prefix}-db-password"

  replication {
    auto {}
  }

  labels = local.common_labels

  depends_on = [google_project_service.services]
}

resource "google_secret_manager_secret_version" "database_password" {
  secret      = google_secret_manager_secret.database_password.id
  secret_data = random_password.database_password.result
}

# Private service connection for Cloud SQL
resource "google_compute_global_address" "private_vpc_connection" {
  name          = "${local.name_prefix}-private-vpc-connection"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.network_id

  depends_on = [google_project_service.services]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = module.vpc.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_vpc_connection.name]

  depends_on = [google_project_service.services]
}

# Cloud SQL PostgreSQL instance
resource "google_sql_database_instance" "postgresql" {
  name             = "${local.name_prefix}-postgresql"
  database_version = "POSTGRES_15"
  region           = var.gcp_region
  deletion_protection = false

  settings {
    tier = var.database_tier

    disk_type       = "PD_SSD"
    disk_size       = 20
    disk_autoresize = true

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = module.vpc.network_id
      ssl_mode                                      = "ENCRYPTED_ONLY"
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = true
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    maintenance_window {
      day          = 7
      hour         = 4
      update_track = "stable"
    }

    user_labels = local.common_labels
  }

  depends_on = [
    google_service_networking_connection.private_vpc_connection,
    google_project_service.services
  ]
}

resource "google_sql_database" "main" {
  name     = var.database_name
  instance = google_sql_database_instance.postgresql.name
}

resource "google_sql_user" "main" {
  name     = var.database_username
  instance = google_sql_database_instance.postgresql.name
  password = random_password.database_password.result
}

# Cloud Run service
module "cloud_run" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "~> 0.21.0"

  service_name = "${local.name_prefix}-service"
  project_id   = var.gcp_project_id
  location     = var.gcp_region
  image        = var.container_image

  service_labels = local.common_labels

  env_vars = [
    {
      name  = "NODE_ENV"
      value = var.environment
    },
    {
      name  = "DATABASE_URL"
      value = "postgresql://${var.database_username}:${random_password.database_password.result}@${google_sql_database_instance.postgresql.private_ip_address}:5432/${var.database_name}?sslmode=require"
    }
  ]

  # VPC connector configuration via template annotations
  template_annotations = {
    "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.id
    "run.googleapis.com/vpc-access-egress" = "private-ranges-only"
    "autoscaling.knative.dev/maxScale" = "10"
    "autoscaling.knative.dev/minScale" = "1"
    "generated-by" = "terraform"
    "run.googleapis.com/client-name" = "terraform"
  }

  # Service configuration
  service_annotations = {
    "run.googleapis.com/ingress" = "all"
    "run.googleapis.com/cpu-throttling" = "false"
  }

  container_concurrency = 80

  # Resource limits
  limits = {
    cpu    = "1000m"
    memory = "512Mi"
  }

  depends_on = [google_project_service.services]
}

# VPC Access Connector for Cloud Run
resource "google_vpc_access_connector" "connector" {
  name          = "${local.name_prefix}-connector"
  region        = var.gcp_region
  network       = module.vpc.network_name
  ip_cidr_range = "10.8.0.0/28"
  max_instances = 3
  min_instances = 2

  depends_on = [google_project_service.services]
}

# IAM for Cloud Run service account
resource "google_service_account" "cloud_run" {
  account_id   = "${local.name_prefix}-cloud-run-sa"
  display_name = "Cloud Run Service Account for ${local.name_prefix}"
}

# Grant permissions to access Cloud SQL
resource "google_project_iam_member" "cloud_run_sql_client" {
  project = var.gcp_project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Grant permissions to access Cloud Storage
resource "google_storage_bucket_iam_member" "cloud_run_storage" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Grant permissions to access Secret Manager
resource "google_secret_manager_secret_iam_member" "cloud_run_secret_accessor" {
  secret_id = google_secret_manager_secret.database_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Cloud Logging for monitoring
resource "google_logging_project_sink" "app_logs" {
  name        = "${local.name_prefix}-app-logs"
  destination = "storage.googleapis.com/${google_storage_bucket.main.name}"
  filter      = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${local.name_prefix}-service\""

  unique_writer_identity = true

  depends_on = [google_project_service.services]
}

# Grant the logging sink write access to the bucket
resource "google_storage_bucket_iam_member" "log_sink" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.app_logs.writer_identity
}