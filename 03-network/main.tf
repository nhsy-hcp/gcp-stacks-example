###
# Create vpc
###

resource "google_compute_network" "vpc" {
  name                            = var.network_name
  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  description                     = var.description
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
}

###
# Create subnet
###
resource "google_compute_subnetwork" "subnetwork" {
  name                     = var.subnet.subnet_name
  ip_cidr_range            = var.subnet.subnet_ip
  region                   = var.subnet.subnet_region
  private_ip_google_access = lookup(var.subnet, "subnet_private_access", "false")

  dynamic "log_config" {
    for_each = coalesce(lookup(var.subnet, "subnet_flow_logs", null), false) ? [{
      aggregation_interval = var.subnet.subnet_flow_logs_interval
      flow_sampling        = var.subnet.subnet_flow_logs_sampling
      metadata             = var.subnet.subnet_flow_logs_metadata
      filter_expr          = var.subnet.subnet_flow_logs_filter
      metadata_fields      = var.subnet.subnet_flow_logs_metadata_fields
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
      filter_expr          = log_config.value.filter_expr
      metadata_fields      = log_config.value.metadata == "CUSTOM_METADATA" ? log_config.value.metadata_fields : null
    }
  }

  network     = google_compute_network.vpc.self_link
  description = lookup(var.subnet, "description", null)
  purpose     = lookup(var.subnet, "purpose", null)
  role        = lookup(var.subnet, "role", null)
}

###
# Create cloud router and nat gateway
###
resource "google_compute_router" "router" {
  count   = var.create_nat_router ? 1 : 0
  name    = var.router_name
  network = google_compute_network.vpc.self_link
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  count                              = var.create_nat_router ? 1 : 0
  name                               = var.router_nat_name
  region                             = var.region
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}