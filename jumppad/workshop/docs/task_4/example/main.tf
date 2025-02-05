terraform {
  required_providers {
    aap = {
      source = "ansible/aap"
      version = "1.1.2"
    }
  }
}

provider "aap" {
  host                 = "https://44.210.128.100"
  username             = var.aap_username
  password             = var.aap_password
  insecure_skip_verify = true
}