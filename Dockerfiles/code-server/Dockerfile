FROM ghcr.io/jumppad-labs/vscode:vscode-v0.5.3

LABEL org.opencontainers.image.source=https://github.com/nicholasjackson/workshop-better-together


ARG TARGETARCH
ARG VAULT_VERSION=1.18.3
ARG PACKER_VERSION=1.12.0
ARG TERRAFORM_VERSION=1.10.5

# Install default packages
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    curl \
    wget \
    zip \
    git \
    jq \
    build-essential \
    gnupg \
    python3-launchpadlib

# Ansible
RUN apt-add-repository --yes --update ppa:ansible/ansible \
    && apt-get install -y ansible

# Install Vault
RUN wget -O vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
  unzip -o vault.zip && \
  mv vault /usr/local/bin

# Install Packer
RUN wget -O packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${TARGETARCH}.zip && \
  unzip -o packer.zip && \
  mv packer /usr/local/bin
  
# Install Terraform
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
  unzip -o terraform.zip && \
  mv terraform /usr/local/bin

# Install VSCode extensions
RUN code-server --install-extension hashicorp.terraform && \
    code-server --install-extension hashicorp.hcl && \
    code-server --install-extension github.github-vscode-theme && \
    code-server --install-extension pkief.material-icon-theme

# Clean packages
RUN rm -rf /var/lib/apt/lists/*