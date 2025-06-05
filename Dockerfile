FROM ubuntu:jammy
ARG DEBIAN_FRONTEND=noninteractive
ARG ORAS_VERSION=1.1.0

# Base system setup
RUN apt update -y && apt install -y \
    gnupg \
    openssh-client \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    curl \
    git \
    jq && \
    apt upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# SSH configuration hardening
RUN sed -i 's/#\s*StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config && \
    echo -e "\nHost *\n    StrictHostKeyChecking no\n" >> /etc/ssh/ssh_config

# Ansible PPA setup
RUN . /etc/os-release && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/ansible.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

# HashiCorp repo setup (Packer/Terraform)
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    . /etc/os-release && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" > /etc/apt/sources.list.d/hashicorp.list

# Google Cloud SDK repo setup
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list

# Install tools
RUN apt update -y && apt install -y \
    ansible \
    packer \
    terraform \
    google-cloud-sdk && \
    rm -rf /var/lib/apt/lists/*

# ORAS install
RUN curl -LO "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz" && \
    mkdir -p oras-install/ && \
    tar -zxf oras_${ORAS_VERSION}_*.tar.gz -C oras-install/ && \
    mv oras-install/oras /usr/local/bin/ && \
    rm -rf oras_${ORAS_VERSION}_*.tar.gz oras-install/

# Pulumi install
RUN curl -fsSL https://get.pulumi.com | sh

# Add Pulumi to PATH
ENV PATH="$PATH:/root/.pulumi/bin"

CMD [""]