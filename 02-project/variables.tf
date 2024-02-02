variable "google_apis" {
  type = set(string)
  default = [
    "compute.googleapis.com",
    "iap.googleapis.com",
  ]
}