output "project" {
  description = "Project id"
  value       = google_compute_network.vpc.project
}

output "network" {
  description = "The created network"
  value       = google_compute_network.vpc
}

output "network_name" {
  description = "Name of VPC"
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "VPC network self link"
  value       = google_compute_network.vpc.self_link
}

output "proxy_subnet" {
  description = "The proxy_subnet resource"
  value       = google_compute_subnetwork.proxy_subnetwork
}

output "proxy_subnet_name" {
  description = "The proxy_subnet resource"
  value       = google_compute_subnetwork.proxy_subnetwork.name
}

output "subnet" {
  description = "The subnet resource"
  value       = google_compute_subnetwork.subnetwork
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.subnetwork.name
}

output "subnets_ip_cidr_ranges" {
  description = "The IP CIDR of the subnet"
  value       = google_compute_subnetwork.subnetwork.ip_cidr_range
}

output "subnet_self_links" {
  description = "The self_link of the subnet"
  value       = google_compute_subnetwork.subnetwork.self_link
}

output "subnet_region" {
  description = "The region of the subnet"
  value       = google_compute_subnetwork.subnetwork.region
}