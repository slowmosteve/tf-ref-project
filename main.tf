# provider
provider "google" {
#   project = var.project_id
  credentials = file("./service-acct/key.json")
  region  = "us-central1"
  zone    = "us-central1-c"
}

# Staging bucket
resource "google_storage_bucket" "staging_bucket" {
  project  = var.project_id
  name     = "${var.project_id}-staging"
}

# Production bucket
resource "google_storage_bucket" "prod_bucket" {
  project  = var.project_id
  name     = "${var.project_id}-prod"
}

# Enable APIs
resource "google_project_service" "enabled_api" {
  for_each                   = toset(var.enabled_api)
  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = false
}
