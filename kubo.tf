resource "google_compute_subnetwork" "kubo-subnet" {
  name          = "${var.prefix}kubo-${var.kubo_region}"
  region        = "${var.kubo_region}"
  ip_cidr_range = "10.0.1.0/24"
  network       = "https://www.googleapis.com/compute/v1/projects/${var.projectid}/global/networks/${var.cf_network}"
}

output "kubo_subnet" {
   value = "${google_compute_subnetwork.kubo-subnet.name}"
}
