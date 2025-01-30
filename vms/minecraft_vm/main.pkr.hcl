variable "jumppad_version" {
  type = string
}

variable "jumppad_images" {
  type    = list(string)
  default = []
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west6-b"
}

packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

source "qemu" "minecraft" {
  vm_name          = "ubuntu-2404-amd64.raw"
  iso_url          = "https://www.releases.ubuntu.com/24.04/ubuntu-24.04.1-live-server-amd64.iso"           
  iso_checksum     = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
  memory           = 1500
  disk_image       = false
  output_directory = "build/os-base"
  accelerator      = "kvm"
  disk_size        = "12000M"
  disk_interface   = "virtio"
  format           = "raw"
  net_device       = "virtio-net"
  boot_wait        = "3s"
  boot_command = [
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall ds=\"nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/\" ",
    "<f10>"
  ]
  http_directory   = "./files"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username     = "packer"
  ssh_password     = "packer"
  ssh_timeout      = "60m"
}

build {
  name    = "iso"
  sources = ["source.qemu.minecraft"]
}