## Enables the required services in the project.
##
## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
#resource "google_project_service" "services" {
#  for_each = toset([
#    "iam.googleapis.com",
#    "cloudresourcemanager.googleapis.com",
#    "sts.googleapis.com",
#    "iamcredentials.googleapis.com"
#  ])
#  service                    = each.value
#  disable_dependent_services = false
#  disable_on_destroy         = false
#}
#
## Creates a workload identity pool to house a workload identity
## pool provider.
##
## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool
#resource "google_iam_workload_identity_pool" "tfc" {
#  provider                  = google-beta
#  workload_identity_pool_id = "tfc-wi-demo"
#
#  lifecycle {
#    prevent_destroy = true
#  }
#}
#
## Creates an identity pool provider which uses an attribute condition
## to ensure that only the specified Terraform Cloud workspace will be
## able to authenticate to GCP using this provider.
##
## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider
#resource "google_iam_workload_identity_pool_provider" "tfc" {
#  provider                           = google-beta
#  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc.workload_identity_pool_id
#  workload_identity_pool_provider_id = "tfc-wi-demo"
#  attribute_mapping = {
#    "google.subject"                        = "assertion.sub",
#    "attribute.aud"                         = "assertion.aud",
#    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase",
#    "attribute.terraform_project_id"        = "assertion.terraform_project_id",
#    "attribute.terraform_project_name"      = "assertion.terraform_project_name",
#    "attribute.terraform_workspace_id"      = "assertion.terraform_workspace_id",
#    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name",
#    "attribute.terraform_organization_id"   = "assertion.terraform_organization_id",
#    "attribute.terraform_organization_name" = "assertion.terraform_organization_name",
#    "attribute.terraform_run_id"            = "assertion.terraform_run_id",
#    "attribute.terraform_full_workspace"    = "assertion.terraform_full_workspace",
#  }
#  oidc {
#    issuer_uri = "https://${var.tfc_hostname}"
#    # The default audience format used by TFC is of the form:
#    # //iam.googleapis.com/projects/{project number}/locations/global/workloadIdentityPools/{pool ID}/providers/{provider ID}
#    # which matches with the default accepted audience format on GCP.
#    #
#    # Uncomment the line below if you are specifying a custom value for the audience instead of using the default audience.
#    # allowed_audiences = [var.tfc_gcp_audience]
#  }
#  attribute_condition = "assertion.sub.startsWith(\"organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}\")"
#
#  lifecycle {
#    prevent_destroy = true
#  }
#}
#
## Creates a service account that will be used for authenticating to GCP.
##
## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
#resource "google_service_account" "tfc" {
#  account_id   = "tfc-wi-demo"
#  display_name = "Terraform Cloud WI Service Account"
#}
#
## Allows the service account to act as a workload identity user.
##
## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
#resource "google_service_account_iam_member" "tfc" {
#  service_account_id = google_service_account.tfc.name
#  role               = "roles/iam.workloadIdentityUser"
#  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc.name}/*"
#
#  depends_on = [
#    google_iam_workload_identity_pool_provider.tfc
#  ]
#}
#
## Updates the IAM policy to grant the service account permissions
## within the project.
##
## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
#resource "google_project_iam_member" "tfc" {
#  for_each = toset([
#    "roles/storage.admin",
#    "roles/viewer"
#  ])
#  project = var.gcp_project_id
#  role    = each.value
#  member  = "serviceAccount:${google_service_account.tfc.email}"
#}
