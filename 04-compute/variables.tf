# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#variable "service_account_email" {}

variable "zone" {}

variable "machine_type" {
  default = "g1-small"
}

variable "instance_name_prefix" {
  default = "gcp-stacks-example"
}

variable "unique_id" {}

variable "compute_sa_email" {}

variable "subnetwork_self_link" {}