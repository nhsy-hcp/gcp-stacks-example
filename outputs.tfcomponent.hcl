output "instance_name" {
  type        = string
  description = "The name of the instance"
  value       = component.compute.instance_name
}

output "instance_zone" {
  type        = string
  description = "The zone of the instance"
  value       = component.compute.instance_zone
}

output "ssh_command" {
  type        = string
  description = "The SSH command to connect to the instance"
  value       = "gcloud compute ssh ${component.compute.instance_name} --zone=${component.compute.instance_zone} --tunnel-through-iap"
}