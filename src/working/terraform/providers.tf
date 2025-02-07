terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
    aap = {
      source = "ansible/aap"
      version = "1.1.2"
    }
    http = {
      source = "hashicorp/http"
      version = "3.4.5"
    }
  }
}