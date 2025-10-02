# gcp-stacks-example

This is an example stacks deployment with Google Cloud.

## Architecture
The following Google Cloud resources are created:
- Compute Engine
- Firewall Rules
- Service Account
- VPC Network

### Modules
The infrastructure is organized into reusable Terraform modules in the `modules/` directory:

- `modules/common` - Generates random string IDs and retrieves common GCP data (zones, project info)
- `modules/compute` - Creates GCP Compute Engine instances with Debian images
- `modules/network` - Creates VPC networks, subnets, firewall rules, cloud routers, and NAT gateways
- `modules/project` - Manages project-level configuration including API enablement, service accounts, and IAM roles

### Bootstrap
The `bootstrap/` directory contains Terraform configuration to set up the initial Terraform Cloud workspace and GCP project prerequisites.

## Prerequisites
- GitHub Repository
- Google Cloud project with owner IAM permissions
- Terraform Cloud organisation
- terraform CLI 

CLI tools can be installed using the following commands documented at https://github.com/hashicorp/homebrew-tap:
```bash
brew install hashicorp/tap/terraform
```

## Initial setup
Fork the repository to your own GitHub account.

Add the `bootstrap/terraform.tfvars` file with the required values.
```bash
tfc_organization_name = "org name"
gcp_project_id        = "project id"
```

Bootstrap the Terraform Cloud workspace and GCP Project with the following commands:
```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

Update `deployments.tfdeploy.hcl` with the required values for:
* audience
* project_id
* service_account_email

```hcl
deployment "us-central1" {
  inputs = {
    identity_token        = identity_token.gcp.jwt
    audience              = "//iam.googleapis.com/projects/123456789/locations/global/workloadIdentityPools/wi-pool-gcp-stacks-example/providers/wi-provider-gcp-stacks-example"
    project_id            = "prj-123456789"
    service_account_email = "gcp-stacks-example@prj-123456789.iam.gserviceaccount.com"
    region                = "us-central1"
  }
}
```
Commit the `deployments.tfdeploy.hcl` file to your GitHub repository.

## Deployment
A new project called stacks should have been created in Terraform Cloud.

Click on the `New` button in the upper right corner and select `Stack`.

Select the GitHub repository to use, name the stack `gcp-stacks-example` and click `Create Stack`.

Click on `Fetch configuration` to load the `deployments.tfdeploy.hcl` file.

Click on the deployment `us-central1`.

Click on the latest plan, e.g. `Plan 1` and click `Approve Plan`.

## Connecting to the Compute Instance

After the deployment completes, you can SSH into the Google Compute Engine instance using the `ssh_command` output. View the outputs in the Terraform Cloud stack, copy the SSH command, and run it in your terminal:

```bash
gcloud compute ssh <instance-name> --zone=<zone> --tunnel-through-iap
```

This command uses Identity-Aware Proxy (IAP) to establish a secure tunnel to the instance without requiring a public IP address.

## Cleanup
To remove the resources created, uncomment the `destroy = true` line in the `deployments.tfdeploy.hcl` file:

```hcl
deployment "us-central1" {
  inputs = {
    identity_token        = identity_token.gcp.jwt
    audience              = "//iam.googleapis.com/projects/123456789/locations/global/workloadIdentityPools/wi-pool-gcp-stacks-example/providers/wi-provider-gcp-stacks-example"
    project_id            = "prj-123456789"
    service_account_email = "gcp-stacks-example@prj-123456789.iam.gserviceaccount.com"
    region                = "us-central1"
  }
  destroy = true
}
```

Commit and push the changes to trigger a destroy plan in Terraform Cloud.