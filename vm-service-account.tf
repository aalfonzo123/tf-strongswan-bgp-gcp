resource "google_service_account" "vm-service-account" {
  account_id   = "vm-service-account"
  display_name = "least privilege service sccount for VMs"
}