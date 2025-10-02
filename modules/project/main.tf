locals {
  sa_name = "${var.compute_sa_name_prefix}-${var.unique_id}"
}

resource "google_compute_project_metadata" "default" {
  metadata = {
    enable-oslogin = "TRUE"
  }
}

resource "google_project_service" "apis" {
  for_each = var.google_apis

  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_service_account" "compute" {
  account_id = local.sa_name
}

resource "google_project_iam_member" "compute" {
  for_each = var.compute_sa_roles
  role     = each.value
  member   = "serviceAccount:${google_service_account.compute.email}"
  project  = var.project_id
}