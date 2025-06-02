FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Base system tools
RUN apt update -y && apt install -y \
    python3 python3-pip python3-venv \
    gnupg openssh-client git jq curl unzip && \
    apt upgrade -y

# SSH config hardening
RUN sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/" /etc/ssh/ssh_config && \
    echo "Host *" >> /etc/ssh/ssh_config

# Add Ansible PPA key (still needed for compatibility, but not using apt ansible anymore)
RUN export "$(sed -n "/UBUNTU_CODENAME.*/p" /etc/os-release)" && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

# Install Python virtual environment and secure Ansible + patched packages
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install ansible cryptography==42.0.0 certifi==2023.7.22 aiohttp==3.9.4

# Make virtualenv binaries globally accessible
ENV PATH="/venv/bin:$PATH"

# Install secure version of packer manually
ENV PACKER_VERSION=1.10.0
RUN curl -fsSL https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o packer.zip && \
    unzip packer.zip -d /usr/local/bin && \
    rm packer.zip

CMD [""]
