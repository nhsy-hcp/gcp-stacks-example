provider "google" {
  project = var.gcp_project_id
  region  = "global"
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = "global"
}

provider "tfe" {
  hostname     = var.tfc_hostname
  organization = var.tfc_organization_name
}