terraform {
  required_version = ">= 0.12"
  required_providers {
    sysdig = {
      source = "local/sysdiglabs/sysdig"
      version = "~> 1.0.0"
    }
  }
}

variable "gcp_project_id" {
  type = string
}

resource "google_service_account" "sa" {
  account_id = "sa-sysdigmonitor"
  display_name = "Sysdig Monitor Service Account"
}

resource "google_project_iam_member" "monitor_account_iam" {
  project = var.gcp_project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_service_account_key" "monitor_account_key" {
  service_account_id = google_service_account.sa.name
}

resource "sysdig_monitor_cloud_account_provider" "provider" {
  platform = "GCP"
  integration_type = "API"
  account_id = var.gcp_project_id
  additional_options = google_service_account_key.monitor_account_key.private_key
}