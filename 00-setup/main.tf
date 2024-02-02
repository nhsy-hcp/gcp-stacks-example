data "google_project" "current" {}

data "tfe_organization" "default" {
  name = var.tfc_organization_name
}

locals {
  audience = "//iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/providers/${var.workload_identity_pool_provider_id}"
}