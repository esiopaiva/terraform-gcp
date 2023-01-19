resource "google_compute_instance" "terraform" {
  project      = "desync-shared-devops-prod-iac"
  name         = "terraform"
  machine_type = "e2-micro"
  zone         = "us-central1-c"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}