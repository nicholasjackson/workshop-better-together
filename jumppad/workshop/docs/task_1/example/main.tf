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
  source = "/var/workshop/images/minecraft-vm.qcow2"
}

resource "libvirt_domain" "domain-ubuntu" {
  name   = "ubuntu-terraform"
  memory = "3096"
  vcpu   = 4

  network_interface {
    network_name = "default"
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
}

//output "ip_address" {
//  value = libvirt_domain.domain-ubuntu.network_interface.0.addresses.0
//}

//output "socat_command" {
//  value = "socat TCP-LISTEN:25565,fork,reuseaddr TCP:${libvirt_domain.domain-ubuntu.network_interface.0.addresses.0}:25565"
//}