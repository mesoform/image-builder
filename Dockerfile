FROM ubuntu:mantic-20231011
ARG DEBIAN_FRONTEND noninteractive

RUN apt update -y && apt install -y gnupg openssh-client git jq curl && apt upgrade -y
RUN sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/" /etc/ssh/ssh_config && \
    echo "Host *" >> /etc/ssh/ssh_config && \
    export "$(sed -n "/UBUNTU_CODENAME.*/p" /etc/os-release)" && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    export "$(sed -n "/UBUNTU_CODENAME.*/p" /etc/os-release)" && \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $UBUNTU_CODENAME main" >> /etc/apt/sources.list

RUN apt update -y && apt install -y ansible packer

CMD [""]
