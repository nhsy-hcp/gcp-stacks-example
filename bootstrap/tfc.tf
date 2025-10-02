# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Runs in this workspace will be automatically authenticated
# to GCP with the permissions set in the GCP policy.
#

#resource "tfe_oauth_client" "default" {
#  name             = "GitHub-OAuth"
#  api_url          = "https://api.github.com"
#  http_url         = "https://github.com"
#  service_provider = "github"
#  organization     = var.tfc_organization_name
#  oauth_token      = var.github_oauth_token
#}

## Connect TFC org to Github OAuth Apps
## https://developer.hashicorp.com/terraform/cloud-docs/vcs/github
#data "tfe_oauth_client" "default" {
#  organization     = var.tfc_organization_name
#  service_provider = "github"
#  name             = "GitHub-OAuth"
#}

# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace
#resource "tfe_workspace" "default" {
#  name         = var.tfc_workspace_name
#  organization = var.tfc_organization_name
#
#  auto_apply          = false
#  description         = "Terraform Cloud and GCP Workload Identity demo"
#  project_id          = data.tfe_project.default.id
#  speculative_enabled = true
#  tag_names = [
#    "demo",
#    "gcp"
#  ]
#  terraform_version = "1.5.2"
#  trigger_patterns  = ["example/**"]
#
#  vcs_repo {
#    branch         = "main"
#    identifier     = var.github_repo
#    oauth_token_id = tfe_oauth_client.default.oauth_token_id
#    #    oauth_token_id = data.tfe_oauth_client.default.oauth_token_id
#  }
#  working_directory = "example"
#}
#
## The following variables must be set to allow runs
## to authenticate to GCP.
##
## https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
#resource "tfe_variable" "enable_gcp_provider_auth" {
#  workspace_id = tfe_workspace.default.id
#
#  key      = "TFC_GCP_PROVIDER_AUTH"
#  value    = "true"
#  category = "env"
#
#  description = "Enable the Workload Identity integration for GCP."
#}
#
#resource "tfe_variable" "tfc_gcp_project_number" {
#  workspace_id = tfe_workspace.default.id
#
#  key      = "TFC_GCP_PROJECT_NUMBER"
#  value    = data.google_project.project.number
#  category = "env"
#
#  description = "The numeric identifier of the GCP project."
#}
#
#resource "tfe_variable" "tfc_gcp_workload_pool_id" {
#  workspace_id = tfe_workspace.default.id
#
#  key      = "TFC_GCP_WORKLOAD_POOL_ID"
#  value    = google_iam_workload_identity_pool.tfc.workload_identity_pool_id
#  category = "env"
#
#  description = "The ID of the workload identity pool."
#}
#
#resource "tfe_variable" "tfc_gcp_workload_provider_id" {
#  workspace_id = tfe_workspace.default.id
#
#  key      = "TFC_GCP_WORKLOAD_PROVIDER_ID"
#  value    = google_iam_workload_identity_pool_provider.tfc.workload_identity_pool_provider_id
#  category = "env"
#
#  description = "The ID of the workload identity pool provider."
#}
#
#resource "tfe_variable" "tfc_gcp_service_account_email" {
#  workspace_id = tfe_workspace.default.id
#
#  key      = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
#  value    = google_service_account.tfc.email
#  category = "env"
#
#  description = "The GCP service account email runs will use to authenticate."
#}
#
## The following variables are optional; uncomment the ones you need!
#
## resource "tfe_variable" "tfc_gcp_audience" {
##   workspace_id = tfe_workspace.my_workspace.id
#
##   key      = "TFC_GCP_WORKLOAD_IDENTITY_AUDIENCE"
##   value    = var.tfc_gcp_audience
##   category = "env"
#
##   description = "The value to use as the audience claim in run identity tokens"
## }
#
#resource "tfe_variable" "tfc_gcp_project_id" {
#  workspace_id = tfe_workspace.default.id
#
#  key      = "project_id"
#  value    = var.gcp_project_id
#  category = "terraform"
#
#  description = "The GCP project id."
#}
#
##data "tfe_organization_run_task" "budgets" {
##  name         = "gcp-runtask-budgets"
##  organization = var.tfc_organization_name
##}
##
##resource "tfe_workspace_run_task" "budgets" {
##  workspace_id      = tfe_workspace.default.id
##  task_id           = data.tfe_organization_run_task.budgets.id
##  stage             = "post_plan"
##  enforcement_level = "mandatory"
##}


resource "tfe_project" "default" {
  name = var.tfc_project_name
}