terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system?socket=/var/run/libvirt/libvirt-sock"
}

variable "vault_addr" {
  type        = string
  description = "Vault address"
  default     = "https://skoaap-public-vault-8683511a.d19fbab7.z1.hashicorp.cloud:8200"
}

variable "vault_namespace" {
  type        = string
  description = "Vault namespace"
  default     = "admin/testorga"
}

variable "server_mac_addr" {
  type        = string
  description = "Fixed MAC address for the server, to enable static ip"
  default     = "52:54:00:00:00:01"
}

variable "server_ip_addr" {
  type        = string
  description = "Static IP address for the server"
  default     = "192.168.16.100"
}

resource "libvirt_network" "minecraft" {
  # the name used by libvirt
  name = "minecraft"
  mode = "nat"

  addresses = ["192.168.16.1/24"]

  dhcp {
    enabled = true
  }
}

resource "libvirt_pool" "ubuntu" {
  name = "ubuntu"
  type = "dir"
  target {
    path = "/var/workshop/pools/ubuntu"
  }
}

resource "libvirt_volume" "ubuntu-qcow2" {
  name   = "ubuntu-qcow2"
  pool   = libvirt_pool.ubuntu.name
  source = "/var/workshop/images/minecraft_task_1/minecraft-task-1.qcow2"
}

resource "libvirt_domain" "domain-ubuntu" {
  name   = "ubuntu-terraform"
  memory = "3096"
  vcpu   = 4

  network_interface {
    network_name   = libvirt_network.minecraft.name
    addresses      = [var.server_ip_addr]
    wait_for_lease = false
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  connection {
    type     = "ssh"
    user     = "packer"
    password = "packer"
    host     = var.server_ip_addr
  }

  provisioner "file" {
    content  = <<-EOF
      VAULT_ADDR=${var.vault_addr}
      VAULT_NAMESPACE=${var.vault_namespace}
    EOF

    destination = "/tmp/minecraft.env"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /etc/minecraft/env",
      "sudo mv /tmp/minecraft.env /etc/minecraft/env/minecraft.env",
      "sudo systemctl restart minecraft"
    ]
  }
}

output "ip_address" {
  value = var.server_ip_addr
}

output "socat_command" {
  value = "socat TCP-LISTEN:25565,fork,reuseaddr TCP:${var.server_ip_addr}:25565"
}