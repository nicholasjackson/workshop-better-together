
####
#  Important this task needs to be executed from the the terminal tab - you cannot use the vscode integrated terminal
####
packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

variable "image_version" {
  type    = string
  default = "1"
}

variable "project_id" {
  type    = string
  default = "jumppad"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zone" {
  type    = string
  default = "europe-west4-b"
}

source "googlecompute" "minecraft" {
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  image_family = "jumppad"
  image_name   = regex_replace("better-workshop-sharedmc-${var.image_version}", "[^a-zA-Z0-9_-]", "-")

  source_image_family = "ubuntu-2204-lts"
  machine_type        = "n1-standard-2"
  disk_size           = 40

  ssh_username = "root"
}

build {
  name    = "iso"
  sources = ["source.googlecompute.minecraft"]

  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/playbook.yml"

    ansible_env_vars = [
      "ANSIBLE_DEPRECATION_WARNINGS=False",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_NOCOLOR=True",
      "ANSIBLE_NOCOWS=1",
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