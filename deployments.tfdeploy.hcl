# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "gcp" {
  # Must be the fully qualified path to the identity provider: //iam.googleapis.com/projects/<PROJECT NUMBER>/locations/global/workloadIdentityPools/<POOL ID>/providers/<PROVIDER ID>
  audience = ["<Set to your GCP token audience>"]
}

deployment "dev" {
  variables = {
    identity_token_file        = identity_token.gcp.jwt_filename
    gcp_audience               = "<Set to your GCP token audience>"
    gcp_service_account_email  = "<Set to your GCP service account email>"
    gcp_project_id             = "Set to your GCP project ID>"
    gcp_region                 = "us-central1"
    gcp_zone                   = "us-central1-a"
  }
}
