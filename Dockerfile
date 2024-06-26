FROM ubuntu:latest

ENV TERRAFORM_VERSION 1.8.4
ENV TERRAGRUNT_VERSION 0.58.12

RUN apt update -y && apt install -y unzip wget curl python3 python3-pip apt-transport-https ca-certificates gnupg git openssh-client && \
    pip3 install awscli --break-system-packages

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod +x terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN curl https://sdk.cloud.google.com > install.sh && bash install.sh --disable-prompts

WORKDIR /app
