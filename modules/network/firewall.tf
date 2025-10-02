resource "google_compute_firewall" "iap" {
  name        = "allow-iap-${var.unique_id}"
  network     = google_compute_network.vpc.self_link
  description = "Allow inbound connections from IAP"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap"]
}