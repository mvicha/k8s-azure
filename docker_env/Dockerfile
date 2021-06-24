FROM debian

#ENV ARM_ENVIRONMENT=china

RUN apt-get update \
  && apt-get install -y \
      bash-completion \
      curl \
      git \
      iputils-ping \
      jq \
      less \
      procps \
      python3 \
      python3-pip \
      unzip \
      vim \
      wget

RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

RUN curl -O https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip \
  && unzip terraform_1.0.0_linux_amd64.zip \
  && mv terraform /usr/bin/terraform_1.0.0 \
  && rm terraform_1.0.0_linux_amd64.zip \
  && chmod 755 /usr/bin/terraform_1.0.0

RUN ln -s /usr/bin/terraform_1.0.0 /usr/bin/terraform

RUN python3 -m pip install \
  ansible \
  azure-cli==2.11.1

RUN ansible-galaxy collection install azure.azcollection

#'azure-cli==2.11.1'

RUN curl -fsSL https://get.docker.com | bash

RUN mkdir ~/.ssh \
  && chmod 700 ~/.ssh

RUN az aks install-cli

RUN echo "source /etc/bash_completion" >> ~/.bashrc \
    && echo "source <(kubectl completion bash)" >> ~/.bashrc

COPY .vimrc /root/.vimrc
COPY ansible.cfg /etc/ansible.cfg

RUN ln -s /SAFE_VOLUME /workdir

