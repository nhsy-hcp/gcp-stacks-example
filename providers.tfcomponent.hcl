# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

required_providers {
  google = {
    source  = "hashicorp/google"
    version = "~> 6.34.0"
  }
  random = {
    source  = "hashicorp/random"
    version = "~> 3.0"
  }
}

provider "random" "default" {}

provider "google" "default" {
  config {
    project = var.project_id
    region  = var.region

    # credentials = jsonencode(
    #   {
    #     "type": "external_account",
    #     "audience": var.audience,
    #     "subject_token_type": "urn:ietf:params:oauth:token-type:jwt"
    #     "token_url": "https://sts.googleapis.com/v1/token",
    #     "credential_source": {
    #       "file": var.identity_token_file
    #     },
    #     "service_account_impersonation_url": format("https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/%s:generateAccessToken", var.service_account_email)
    #   }
    # )

    external_credentials {
      audience              = var.audience
      service_account_email = var.service_account_email
      identity_token        = var.identity_token
    }
  }
}
