resource "google_compute_network" "test-vpc" {
  name = "test-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "test-subnet" {
  name          = "test-subnet"
  ip_cidr_range = "10.80.0.0/16"
  region        = "us-east4"
  network       = google_compute_network.test-vpc.id
}

resource "google_compute_firewall" "test-vpc-allow-iap" {
  name    = "test-vpc-allow-iap"
  network = google_compute_network.test-vpc.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "allow-from-strongswan-vpc" {
  name    = "allow-from-strongswan-vpc"
  network = google_compute_network.strongswan-vpc.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22","800"]
  }

  allow {
    protocol = "icmp"    
  }

  source_ranges = [var.strongswan-subnet-cidr, var.strongwan-bgp-ip]
}

resource "google_compute_router" "test-vpc-router" {
  name    = "test-vpc-router"
  region  = var.region
  network = google_compute_network.test-vpc.id
}

resource "google_compute_router_nat" "test-vpc-router-nat" {
  name                               = "test-vpc-router-nat"
  router                             = google_compute_router.test-vpc-router.name
  region                             = google_compute_router.test-vpc-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}