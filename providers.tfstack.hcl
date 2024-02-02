# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

required_providers {
  google = {
    source  = "hashicorp/google"
    version = "~> 5.12.0"
  }
}

provider "google" "default" {
  config {
    project = var.gcp_project_id
    region  = var.gcp_region
    zone    = var.gcp_zone
    credentials = jsonencode(
      {
        "type": "external_account",
        "audience": var.gcp_audience,
        "subject_token_type": "urn:ietf:params:oauth:token-type:jwt",
        "token_url": "https://sts.googleapis.com/v1/token",
        "credential_source": {
          "file": var.identity_token_file
        },
        "service_account_impersonation_url": format("https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/%s:generateAccessToken", var.gcp_service_account_email)
      }
    )
  }
}
