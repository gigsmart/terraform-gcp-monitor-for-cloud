terraform {
  required_version = ">= 0.12"
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">=0.5.47"
    }
    google = {
      source  = "hashicorp/google"
      version = ">=4.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.4.3"
    }
  }
}

resource "random_id" "account_id" {
  prefix      = "sa-sysdigmonitor-"
  byte_length = 2
}

resource "google_service_account" "sa" {
  account_id   = random_id.account_id.dec
  display_name = "Sysdig Monitor Service Account"
  project      = var.gcp_project_id
}

resource "google_project_iam_member" "monitor_account_iam" {
  project = var.gcp_project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_service_account_key" "monitor_account_key" {
  service_account_id = google_service_account.sa.name
}

resource "sysdig_monitor_cloud_account" "provider" {
  cloud_provider     = "GCP"
  integration_type   = "API"
  account_id         = var.gcp_project_id
  additional_options = google_service_account_key.monitor_account_key.private_key
}
