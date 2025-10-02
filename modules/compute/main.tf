# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "default" {
  name         = "${var.instance_name_prefix}-${var.unique_id}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
    }
  }

  network_interface {
    subnetwork = var.subnetwork_self_link
    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    email  = var.compute_sa_email
    scopes = ["cloud-platform"]
  }
  tags = ["iap"]
}
