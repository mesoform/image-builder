FROM ubuntu:20.04
ARG DEBIAN_FRONTEND noninteractive

# Install base tools
RUN apt update -y && apt install -y gnupg openssh-client git jq curl python3-pip && apt upgrade -y

# Disable SSH strict host key checking
RUN sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/" /etc/ssh/ssh_config && \
    echo "Host *" >> /etc/ssh/ssh_config \

# Add Ansible PPA
RUN export "$(sed -n "/UBUNTU_CODENAME.*/p" /etc/os-release)" && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

# Add HashiCorp repo
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    export "$(sed -n "/UBUNTU_CODENAME.*/p" /etc/os-release)" && \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $UBUNTU_CODENAME main" >> /etc/apt/sources.list

# Install Ansible and Packer
RUN apt update -y && apt install -y ansible packer

# Fix certifi CVE-2023-37920
RUN pip3 install --upgrade certifi

CMD [""]
