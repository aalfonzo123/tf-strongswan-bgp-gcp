resource "google_compute_network" "strongswan-vpc" {
  name = "strongswan-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "strongswan-subnet" {
  name          = "strongswan-subnet"
  ip_cidr_range = var.strongswan-subnet-cidr
  region        = "us-east4"
  network       = google_compute_network.strongswan-vpc.id
}


resource "google_compute_firewall" "strongswan-vpc-allow-iap" {
  name    = "strongswan-vpc-allow-iap"
  network = google_compute_network.strongswan-vpc.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "allow-gcp-vpn" {
  name    = "allow-gcp-vpn"
  network = google_compute_network.strongswan-vpc.name
  direction = "INGRESS"

  allow {
    protocol = "udp"
    ports    = ["500", "4500"]
  }

 allow {
    protocol = "esp"
  }

  source_ranges = [google_compute_ha_vpn_gateway.ha-gateway.vpn_interfaces.0.ip_address]
}

