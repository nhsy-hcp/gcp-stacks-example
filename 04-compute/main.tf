# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "default" {
  name         = "${var.instance_name_prefix}-${var.unique_id}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

#  metadata = {
#    ssh-keys = "user:${data.http.ssh_key.response_body}"
#  }

  service_account {
    email  = var.service_account_email
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
