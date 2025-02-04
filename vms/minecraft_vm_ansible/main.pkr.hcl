packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

source "qemu" "minecraft" {
  vm_name          = "minecraft-vm-ansible.qcow2"
  iso_url          = "../build/os-base/ubuntu-2404-amd64.qcow2"
  iso_checksum     = "none"
  disk_image       = true
  memory           = 1500
  output_directory = "../build/minecraft_vm"
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

  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/playbook.yml"

    ansible_env_vars = [
      "ANSIBLE_DEPRECATION_WARNINGS=False",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_NOCOLOR=True",
      "ANSIBLE_NOCOWS=1",
      "VAULT_NAMESPACE=${var.vault_namespace}",
      "VAULT_URL=${var.vault_url}",
      "ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3"
    ]

    extra_arguments = [
      "--ssh-extra-args",
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o IdentitiesOnly=yes",
      "--scp-extra-args",
      "'-O'"
    ]
  }

}

