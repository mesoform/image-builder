FROM ubuntu:lunar
ARG DEBIAN_FRONTEND=noninteractive
ARG ORAS_VERSION=1.1.0

RUN apt update -y && apt install -y gnupg openssh-client apt-transport-https ca-certificates git jq curl gnupg software-properties-common && apt upgrade -y

RUN sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/" /etc/ssh/ssh_config && \
    echo "Host *" >> /etc/ssh/ssh_config && \
    export "$(sed -n "/UBUNTU_CODENAME.*/p" /etc/os-release)" && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    export "$(sed -n "/UBUNTU_CODENAME.*/p" /etc/os-release)" && \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $UBUNTU_CODENAME main" >> /etc/apt/sources.list

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&  \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.asc

RUN apt update -y && apt install -y ansible packer terraform google-cloud-sdk

RUN curl -LO "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz" && \
    mkdir -p oras-install/ && \
    tar -zxf oras_${ORAS_VERSION}_*.tar.gz -C oras-install/ && \
    mv oras-install/oras /usr/local/bin/ && \
    rm -rf oras_${ORAS_VERSION}_*.tar.gz oras-install/

RUN curl -fsSL https://get.pulumi.com | sh

ENV PATH="$PATH:/root/.pulumi/bin"


CMD [""]
