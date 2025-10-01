# gcp-stacks-example

This is an example stacks deployment with Google Cloud.

## Architecture
The following Google Cloud resources are created:
- Compute Engine
- Firewall Rules
- Service Account
- VPC Network

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

Add the `00-setup/terraform.tfvars` file with the required values.
```bash
tfc_organization_name = "org name"
gcp_project_id        = "project id"
```

Bootstrap the Terraform Cloud workspace and GCP Project with the following commands:
```bash
cd 00-setup
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

## Cleanup
To remove the resources created select the `Destruction and Deletion` option in the Terraform Cloud stack and select `Create destroy plan`.