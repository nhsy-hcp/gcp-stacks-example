output "audience" {
  value = local.audience
}

output "service_account_email" {
  value = google_service_account.tfc.email
}

#output "audience" {
#  value = google_iam_workload_identity_pool_provider.tfc.oidc[0].allowed_audiences[0]
#}