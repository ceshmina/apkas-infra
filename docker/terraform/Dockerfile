FROM ubuntu:24.04

RUN apt update && apt install -y wget unzip

RUN wget https://releases.hashicorp.com/terraform/1.9.3/terraform_1.9.3_linux_arm64.zip \
    && unzip terraform_1.9.3_linux_arm64.zip \
    && cp terraform /usr/local/bin
