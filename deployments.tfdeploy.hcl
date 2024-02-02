# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "gcp" {
  # Must be the fully qualified path to the identity provider: //iam.googleapis.com/projects/<PROJECT NUMBER>/locations/global/workloadIdentityPools/<POOL ID>/providers/<PROVIDER ID>
  audience = ["//iam.googleapis.com/projects/438759265111/locations/global/workloadIdentityPools/wi-pool-gcp-stacks-example/providers/wi-provider-gcp-stacks-example"]
}

deployment "dev" {
  variables = {
    identity_token_file        = identity_token.gcp.jwt_filename
    gcp_audience               = "//iam.googleapis.com/projects/438759265111/locations/global/workloadIdentityPools/wi-pool-gcp-stacks-example/providers/wi-provider-gcp-stacks-example"
    gcp_service_account_email  = "gcp-stacks-example@hc-49356fcfe8ac4451a14e3b2d6a4.iam.gserviceaccount.com"
    gcp_project_id             = "hc-49356fcfe8ac4451a14e3b2d6a4"
    gcp_region                 = "us-central1"
    gcp_zone                   = "us-central1-a"
  }
}
