output "instance_name" {
  value       = google_compute_instance.default.name
  description = "The name of the compute instance"
}

output "instance_self_link" {
  value       = google_compute_instance.default.self_link
  description = "The self link of the compute instance"
}

output "instance_zone" {
  value       = google_compute_instance.default.zone
  description = "The zone of the compute instance"
}