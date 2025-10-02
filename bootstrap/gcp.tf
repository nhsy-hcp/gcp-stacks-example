# Enables the required services in the project.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "serviceusage.googleapis.com",
    "sts.googleapis.com"
  ])
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Creates a workload identity pool to house a workload identity
# pool provider.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool
resource "google_iam_workload_identity_pool" "tfc" {
  provider                  = google-beta
  workload_identity_pool_id = var.workload_identity_pool_id

  lifecycle {
    prevent_destroy = true
  }
}

# Creates an identity pool provider which uses an attribute condition
# to ensure that only the specified Terraform Cloud workspace will be
# able to authenticate to GCP using this provider.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider
resource "google_iam_workload_identity_pool_provider" "tfc" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_pool_provider_id
  attribute_mapping = {
    "google.subject"                            = "assertion.sub",
    "attribute.aud"                             = "assertion.aud"
    "attribute.terraform_operation"             = "assertion.terraform_operation",
    "attribute.terraform_stack_deployment_name" = "assertion.terraform_stack_deployment_name",
    "attribute.terraform_stack_id"              = "assertion.terraform_stack_id",
    "attribute.terraform_stack_name"            = "assertion.terraform_stack_name",
    "attribute.terraform_project_id"            = "assertion.terraform_project_id",
    "attribute.terraform_project_name"          = "assertion.terraform_project_name",
    "attribute.terraform_organization_id"       = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name"     = "assertion.terraform_organization_name",
    "attribute.terraform_plan_id"               = "assertion.terraform_plan_id"
  }
  oidc {
    issuer_uri        = "https://${var.tfc_hostname}"
    allowed_audiences = [var.tfc_gcp_audience]
  }
  # Example subject format: organization:org-RCDSHBfLu9e1e8oZ:project:prj-KRWRrGi7hfnznL59:stack:st-qNWJBTiZZrzfYWiC:deployment:staging:operation:apply
  # attribute_condition = "assertion.sub.startsWith(\"organization:${data.tfe_organization.default.id}:project:${tfe_project.default.id}\")"
  attribute_condition = "assertion.sub.startsWith(\"organization:${var.tfc_organization_name}:project:${tfe_project.default.name}:stack\")"
  # attribute_condition = "assertion.aud == \"${var.tfc_gcp_audience}\""

  lifecycle {
    prevent_destroy = true
  }
}

# Creates a service account that will be used for authenticating to GCP.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "tfc" {
  account_id   = var.service_account_id
  display_name = "Terraform Cloud WI Service Account"
}

# Allows the service account to act as a workload identity user.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "tfc" {
  for_each = toset([
    "roles/iam.workloadIdentityUser",
  ])
  service_account_id = google_service_account.tfc.id
  role               = each.value
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/attribute.terraform_project_id/${tfe_project.default.id}"
  # member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc.name}/*"

  depends_on = [
    google_iam_workload_identity_pool_provider.tfc
  ]
}

# Updates the IAM policy to grant the service account permissions
# within the project.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "tfc" {
  for_each = toset([
    "roles/compute.admin",
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin",
    "roles/viewer"
  ])
  project = var.gcp_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.tfc.email}"
}
