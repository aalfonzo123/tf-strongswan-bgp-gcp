# gcloud compute ssh test-vm --zone=us-east4-a --tunnel-through-iap
resource "google_compute_instance" "test-vm" {
  name                      = "test-vm"
  machine_type              = "e2-medium"
  zone                      = "${var.region}-a"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      size  = "30"
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.test-subnet.id
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