output "strongswan-vm-local-ip" {
    value = google_compute_instance.strongswan-vm.network_interface.0.network_ip
}

output "strongswan-vm-public-ip" {
    value = google_compute_address.strongswan-public-ip.address
}

output "gcp-vpn-public-ip" {
    value = google_compute_ha_vpn_gateway.ha-gateway.vpn_interfaces.0.ip_address
}

output "strongswan-subnet-cidr" {
    value = var.strongswan-subnet-cidr
}

output "test-vm-local-ip" {
    value = google_compute_instance.test-vm.network_interface.0.network_ip
}