terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.55.0"
    }
  }
}

provider "google" {
  credentials = file("/key.json")

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "wireguard_network" {
  name                    = "wireguard-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "wireguard_subnet" {
  name          = "wireguard-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.wireguard_network.id
}

resource "google_compute_firewall" "wireguard_firewall" {
  name    = "wireguard-firewall"
  network = google_compute_network.wireguard_network.name

  allow {
    protocol = "udp"
    ports    = ["51820"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["wireguard-instance"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "wireguard_address" {
  name = "wireguard-address"
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_compute_instance" "wireguard_instance" {
  name         = "wireguard-instance"
  machine_type = "e2-micro"

  tags = ["wireguard-instance"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-101-17162-127-8"
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.wireguard_subnet.name

    access_config {
      nat_ip = google_compute_address.wireguard_address.address
    }
  }

  metadata = {
    user-data = data.template_file.user_data.rendered
    ssh-keys  = "dev:${tls_private_key.ssh_key.public_key_openssh}"
  }
}

data "template_file" "user_data" {
  template = file("./cloud-init.yml")
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "local_file" "ssh_key" {
  content         = tls_private_key.ssh_key.private_key_openssh
  file_permission = "400"
  filename        = "/.ssh/ssh_key"
}

resource "local_file" "ssh_public_key" {
  content         = tls_private_key.ssh_key.public_key_openssh
  file_permission = "400"
  filename        = "/.ssh/ssh_key.pub"
}

output "instance_ip_addr" {
  value = google_compute_address.wireguard_address.address
}
