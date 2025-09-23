# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "identity_token" {
  type        = string
  ephemeral   = true
  description = "JWT identity token"
}

# variable "identity_token_file" {
#   type        = string
#   description = "Path to the file containing the identity token. This file is created by Terraform Cloud when you configure the GCP identity_token block in your deployment."
# }

variable "audience" {
  type        = string
  description = "The fully qualified GCP identity provider name, e.g. '//iam.googleapis.com/projects/270867328173/locations/global/workloadIdentityPools/my-tfc-pool/providers/the-tfc-provider'. This is the same audience value as you've configured in the identity_token block. Google requires this audience value to be set in the service account file itself as well as the token claim."
}

variable "service_account_email" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}
