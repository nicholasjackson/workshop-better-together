packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

source "qemu" "minecraft" {
  vm_name          = "minecraft-vm.qcow2"
  iso_url          = "../build/ubuntu-2404-amd64.qcow2"
  iso_checksum     = "none"
  disk_image       = true
  memory           = 1500
  output_directory = "../build"
  accelerator      = "kvm"
  disk_size        = "12000M"
  disk_interface   = "virtio"
  format           = "raw"
  net_device       = "virtio-net"
  boot_wait        = "3s"
  http_directory   = "./files"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username     = "packer"
  ssh_password     = "packer"
  ssh_timeout      = "60m"
  headless         = true
}

build {
  name    = "iso"
  sources = ["source.qemu.minecraft"]

  provisioner "file" {
    source      = "files/provision.sh"
    destination = "/tmp/provision.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo bash /tmp/provision.sh",
      "rm -f /tmp/provision.sh"
    ]
  }
}