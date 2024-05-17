# the file is called ha-vpn, but we will be using 1 tunnel only

resource "google_compute_ha_vpn_gateway" "ha-gateway" {
  name       = "ha-gateway"
  region     = var.region
  network    = google_compute_network.test-vpc.id
}

resource "google_compute_external_vpn_gateway" "peer-strongswan-gateway" {
  name            = "peer-strongswan-gateway"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  interface {
    id         = 0
    ip_address = google_compute_address.strongswan-public-ip.address
  }
}

resource "google_compute_router" "gcp-router" {
  name     = "gcp-router"
  network  = google_compute_network.test-vpc.name
  region     = var.region
  bgp {
    asn = var.gcp-router-asn
  }
}

resource "google_compute_router_interface" "gcp-router-interface1" {
  name       = "gcp-router-interface1"
  router     = google_compute_router.gcp-router.name
  region     = var.region
  ip_range   = var.bgp-cidr
  vpn_tunnel = google_compute_vpn_tunnel.gcp-tunnel1.name
}

resource "google_compute_router_peer" "gcp-router-peer1" {
  name                      = "gcp-router-peer1"
  router                    = google_compute_router.gcp-router.name
  region                    = var.region
  peer_ip_address           = var.strongwan-bgp-ip
  peer_asn                  = var.strongswan-router-asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.gcp-router-interface1.name
}

resource "google_compute_vpn_tunnel" "gcp-tunnel1" {
  name                            = "gcp-tunnel1"
  region                          = "us-east4"
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha-gateway.id
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.peer-strongswan-gateway.id
  peer_external_gateway_interface = 0
  shared_secret                   = var.shared-secret
  router                          = google_compute_router.gcp-router.id
}