FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Install base system dependencies
RUN apt update -y && apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    gnupg \
    openssh-client \
    git \
    jq \
    curl && \
    apt upgrade -y

# Create virtual environment and install Ansible with patched packages
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install ansible cryptography==42.0.0 certifi==2023.7.22 aiohttp==3.9.4

# Make virtualenv's binaries available in PATH
ENV PATH="/venv/bin:$PATH"

RUN sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/" /etc/ssh/ssh_config && \
    echo "Host *" >> /etc/ssh/ssh_config

CMD [""]