output "audience" {
  value = local.audience
}

output "service_account_email" {
  value = google_service_account.tfc.email
}

output project_id {
  value = data.google_project.current.id
}

output project_number {
  value = data.google_project.current.number
}