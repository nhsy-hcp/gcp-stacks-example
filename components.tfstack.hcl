# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

component "common" {
  source = "./01-common"
  inputs = {
    project_id = var.project_id
    region     = var.region
  }
  providers = {
    google = provider.google.default
    random = provider.random.default
  }
}

component "project" {
  source = "./02-project"
  inputs = {
    project_id = var.project_id
    unique_id  = component.common.unique_id
  }
  providers = {
    google = provider.google.default
  }
}

component "network" {
  source = "./03-network"
  inputs = {
    network_name    = format("%s-%s", "vpc", component.common.unique_id)
    project_id      = var.project_id
    region          = var.region
    router_name     = format("%s-%s", "cr", component.common.unique_id)
    router_nat_name = format("%s-%s", "nr", component.common.unique_id)
    subnet = {
      subnet_name               = format("%s-%s", "snet", component.common.unique_id)
      subnet_ip                 = "10.64.0.0/16"
      subnet_region             = var.region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
    unique_id  = component.common.unique_id
  }
  providers = {
    google = provider.google.default
  }
}

component "compute" {
  source = "./04-compute"
  inputs = {
    compute_sa_email     = component.project.compute_sa_email
    subnetwork_self_link = component.network.subnet_self_link
    unique_id            = component.common.unique_id
    zone                 = component.common.zone
  }
  providers = {
    google = provider.google.default
  }
}
