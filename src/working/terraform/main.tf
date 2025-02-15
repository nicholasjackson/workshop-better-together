provider "libvirt" {
  uri = "qemu:///system?socket=/var/run/libvirt/libvirt-sock"
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

variable "vault_addr" {
  type = string
}

variable "vault_namespace" {
  type = string
}

variable "gemini_api_key" {
  type = string
}

variable "image_source" {
  type = string
  default = "/var/workshop/images/minecraft_task_1/minecraft-task-1.qcow2"
}

resource "libvirt_network" "minecraft" {
  # the name used by libvirt
  name = "minecraft"
  mode = "nat"

  addresses = ["192.168.16.0/24"]

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
  replace_triggered_by = [
      var.image_source,
    ]
}

resource "libvirt_volume" "ubuntu-qcow2" {
  name   = "ubuntu-qcow2"
  pool   = libvirt_pool.ubuntu.name
  source = var.image_source

  replace_triggered_by = [
      var.image_source,
    ]
}

resource "libvirt_domain" "domain-ubuntu" {
  name   = "ubuntu-terraform"
  memory = "3096"
  vcpu   = 4

  replace_triggered_by = [
      var.image_source,
    ]

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
    type        = "ssh"
    user        = "packer"
    password    = "packer"
    host        = var.server_ip_addr 
  }

  provisioner "file" {
    content  = <<-EOF
      MINECRAFT_URL="localhost"
      MINECRAFT_USER="HashiCorp_Nic"
      MINECRAFT_STARTING_LOCATION="-1106 63 -1652"
      MINECRAFT_ENABLE_FOLLOW="true"
      GEMINI_API_KEY=${var.gemini_api_key}
      GEMINI_HISTORY_FILE="./history/task_2.json"
    EOF

    destination = "/tmp/bot.env"
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
      "sudo mkdir -p /etc/minecraft/env",
      "sudo mv /tmp/minecraft.env /etc/minecraft/env/minecraft.env",
      "sudo systemctl restart minecraft",

      "sudo mkdir -p /etc/bot/env",
      "sudo mv /tmp/bot.env /etc/bot/env/bot.env",

    ]
  }
}

output "server_address" {
  value = "${var.server_ip_addr}"
}