terraform {
  required_version = ">=1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.12.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.12.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.51.0"
    }
  }
}