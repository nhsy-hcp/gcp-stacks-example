# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "gcp" {
  # Must be the fully qualified path to the identity provider: //iam.googleapis.com/projects/<PROJECT NUMBER>/locations/global/workloadIdentityPools/<POOL ID>/providers/<PROVIDER ID>
  audience = ["//iam.googleapis.com/projects/645576693893/locations/global/workloadIdentityPools/wi-pool-gcp-stacks-example/providers/wi-provider-gcp-stacks-example"]
}

deployment "us-central1" {
  variables = {
    audience               = "//iam.googleapis.com/projects/645576693893/locations/global/workloadIdentityPools/wi-pool-gcp-stacks-example/providers/wi-provider-gcp-stacks-example"
    identity_token_file    = identity_token.gcp.jwt_filename
    project_id             = "hc-777a6a596c424ec2a1dfc3e017c"
    service_account_email  = "gcp-stacks-example@hc-777a6a596c424ec2a1dfc3e017c.iam.gserviceaccount.com"
    region                 = "us-central1"
  }
}
