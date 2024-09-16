FROM ubuntu:lunar
ARG DEBIAN_FRONTEND=noninteractive
ARG ORAS_VERSION=1.1.0
ARG TERRAFORM_VERSION=1.9.3
ARG PACKER_VERSION=1.11.2

COPY configure_env.sh /scripts/configure_env.sh

RUN apt update -y && apt install -y gnupg openssh-client apt-transport-https ca-certificates git jq curl gnupg software-properties-common wget zip unzip gettext-base && apt upgrade -y

RUN sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/" /etc/ssh/ssh_config && \
    echo "Host *" >> /etc/ssh/ssh_config && \
    export "$(sed -n "/UBUNTU_CODENAME.*/p" /etc/os-release)" && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&  \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.asc

RUN apt update -y && apt install ansible google-cloud-sdk -y

RUN apt install google-cloud-sdk-gke-gcloud-auth-plugin python3-pip -y && pip install poetry --break-system-packages

RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"  && \
    unzip -qn terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN wget "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"  && \
    unzip -qn packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -rf packer_${PACKER_VERSION}_linux_amd64.zip

RUN curl -LO "https://github.com/oras-project/oras/releases/download/v${ORAS_VERSION}/oras_${ORAS_VERSION}_linux_amd64.tar.gz" && \
    mkdir -p oras-install/ && \
    tar -zxf oras_${ORAS_VERSION}_*.tar.gz -C oras-install/ && \
    mv oras-install/oras /usr/local/bin/ && \
    rm -rf oras_${ORAS_VERSION}_*.tar.gz oras-install/

RUN curl -fsSL https://get.pulumi.com | sh

ENV PATH="$PATH:/root/.pulumi/bin"

CMD [""]
