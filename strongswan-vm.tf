resource "google_compute_address" "strongswan-public-ip" {
  name = "ipv4-address"
  address_type = "EXTERNAL"
  region     = var.region
}

resource "google_compute_instance" "strongswan-vm" {
  name                      = "strongswan-vm"
  machine_type              = "e2-medium"
  zone                      = "us-east4-a"
  allow_stopping_for_update = true


  # strongswan installation and config were done manually
  # the steps are not in a startup script
  # see "Strongswan VPN to GCP" slides
  boot_disk {
    initialize_params {
      size  = "30"
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.strongswan-subnet.id
    access_config {
      nat_ip = google_compute_address.strongswan-public-ip.address
    }
  }

  scheduling {
    provisioning_model = "SPOT"
    # provisioning_model = "STANDARD"
    preemptible                 = true
    automatic_restart           = false
    instance_termination_action = "STOP"
  }

  service_account {
    email  = google_service_account.vm-service-account.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    ignore_changes = [metadata["ssh-keys"]]
  }
}



