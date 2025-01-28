packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

source "qemu" "minecraft" {
  vm_name          = "ubuntu-2404-amd64.qcow2"
  iso_url          = "https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso"
  iso_checksum     = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
  memory           = 1500
  output_directory = "build/os-base"
  accelerator      = "kvm"
  disk_size        = "12000M"
  disk_interface   = "virtio"
  format           = "qcow2"
  boot_wait        = "5s"
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]
  http_directory   = "files"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username     = "packer"
  ssh_password     = "packer"
  ssh_timeout      = "10m"
  headless         = true
}

build {
  name    = "iso"
  sources = ["source.qemu.minecraft"]
}