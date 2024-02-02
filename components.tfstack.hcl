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
  }

}


component "compute" {
  source = "./04-compute"
  inputs = {
#    public_ssh_key_url = var.public_ssh_key_url
  }
  providers = {
    google = provider.google.default
  }
}
