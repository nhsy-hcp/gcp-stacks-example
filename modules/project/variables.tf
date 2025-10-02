variable "google_apis" {
  type = set(string)
  default = [
    "compute.googleapis.com",
    "iap.googleapis.com"
  ]
}

variable "project_id" {
  description = "Project ID to deploy into"
  type        = string
}

variable "compute_sa_roles" {
  type = set(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer",
  ]
}

variable "compute_sa_name_prefix" {
  type    = string
  default = "compute"
}

variable "unique_id" {}