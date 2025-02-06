terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    google = {
      source = "hashicorp/google"
      version = "6.19.0"
    }
  }
}

variable "cloudflare_zone" {
  type = string
}

data "google_compute_network" "default" {
  name = "default"
}

resource "google_service_account" "default" {
  account_id   = "sko-minecraft"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  name         = "minecraft-shared"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"

  tags = ["sko"]

  boot_disk {
    initialize_params {
      image = "jumppad/better-workshop-sharedmc-1"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "default" {
  name    = "minecraft"
  network = data.google_compute_network.default.id

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }

  target_tags = ["sko"]
}

resource "cloudflare_dns_record" "minecraft" {
  zone_id = var.cloudflare_zone
  content = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  name    = "sko-minecraft.hashicraft.com"
  proxied = false
  ttl  = 360
  type = "A"
}

output "server_uri" {
  value = cloudflare_dns_record.minecraft.name
}

output "server_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

output "ssh_connection" {
  value = "gcloud compute ssh --zone=us-central1-a ${google_compute_instance.default.name}"
}
