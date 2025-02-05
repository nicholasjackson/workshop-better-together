#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "waiting 180 seconds for cloud-init to update /etc/apt/sources.list"
timeout 180 /bin/bash -c \
  'until stat /var/lib/cloud/instance/boot-finished 2>/dev/null; do echo waiting ...; sleep 1; done'

apt-get update && apt-get -y upgrade
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    sudo \
    unzip \
    git \
    curl \
    jq \
    vim \
    qemu-kvm \
    libvirt-daemon-system \
    socat

# Install Docker
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

apt-get update && apt-get install -y docker-ce

# Install Jumppad
curl -s -L https://github.com/jumppad-labs/jumppad/releases/download/${JUMPPAD_VERSION}/jumppad_${JUMPPAD_VERSION}_linux_x86_64.tar.gz | tar -xz
mv jumppad /usr/local/bin/jumppad
chmod +x /usr/local/bin/jumppad

cp /tmp/resources/jumppad-connector.service /etc/systemd/system/jumppad-connector.service

systemctl daemon-reload
systemctl enable jumppad-connector.service

# Pre-pull docker images
for IMAGE in $JUMPPAD_IMAGES; do
  docker pull $IMAGE
done  

# Create the workshop directories
mkdir -p /var/workshop/images/base
mkdir -p /var/workshop/images/minecraft_1
mkdir -p /var/workshop/pools

# Add the base qemu images
curl -L -o minecraft_base.tar https://storage.googleapis.com/jumppad_sko/minecraft_base.tar
tar -xzf minecraft_base.tar -C /var/workshop/images/minecraft_1

curl -L -o ubuntu_base.tar https://storage.googleapis.com/jumppad_sko/ubuntu-2404-amd64.tar.gz
tar -xzf ubuntu_base.tar -C /var/workshop/images/base

# Configure apparmor
systemctl stop apparmor
systemctl disable apparmor

# Add HashiCorp tools
TARGETARCH=amd64
VAULT_VERSION=1.18.3
PACKER_VERSION=1.12.0
TERRAFORM_VERSION=1.10.5

# Ansible
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

# Install Vault
wget -O vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
  unzip -o vault.zip && \
  mv vault /usr/local/bin

# Install Packer
wget -O packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${TARGETARCH}.zip && \
  unzip -o packer.zip && \
  mv packer /usr/local/bin
  
# Install Terraform
wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
  unzip -o terraform.zip && \
  mv terraform /usr/local/bin