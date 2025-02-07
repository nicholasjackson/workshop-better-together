####
#  Important this task needs to be executed from the the terminal tab - you cannot use the vscode integrated terminal
####
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
  iso_url          = "../build/base/ubuntu-2404-amd64.qcow2"
  output_directory = "../build/minecraft_vm_ansible"
  #iso_url          = "/var/workshop/images/base/ubuntu-2404-amd64.qcow2"
  #output_directory = "/var/workshop/images/minecraft_vm_ansible"
  iso_checksum     = "none"
  disk_image       = true
  memory           = 1500
  accelerator      = "kvm"
  disk_size        = "12000M"
  disk_interface   = "virtio"
  format           = "raw"
  net_device       = "virtio-net"
  boot_wait        = "3s"
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
    user          = "packer"

    ansible_env_vars = [
      "ANSIBLE_DEPRECATION_WARNINGS=False",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_NOCOLOR=True",
      "ANSIBLE_NOCOWS=1",
      "VAULT_NAMESPACE=${var.vault_namespace}",
      "VAULT_URL=${var.vault_url}",
      "ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3",
      "ANSIBLE_REMOTE_TEMP=/tmp/ansible"
    ]

    extra_arguments = [
      "--ssh-extra-args",
      "-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o IdentitiesOnly=yes",
      "--scp-extra-args",
      "'-O'"
    ]
  }

}