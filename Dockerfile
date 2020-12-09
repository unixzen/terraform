FROM debian:latest as builder

ARG TERRAFORM_VERSION=0.14.2
ARG TERRAFORM_PROVIDER_VERSION=0.47.0

RUN set -ex \
  && apt-get update && apt-get install -y \
    curl \
    unzip

RUN curl https://releases.hashicorp.com/terraform/0.12.28/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && cd /tmp \
  && unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && curl https://releases.hashicorp.com/terraform-provider-yandex/${TERRAFORM_PROVIDER_VERSION}/terraform-provider-yandex_${TERRAFORM_PROVIDER_VERSION}_linux_amd64.zip -o /tmp/terraform-provider-yandex_${TERRAFORM_PROVIDER_VERSION}_linux_amd64.zip \
  && unzip /tmp/terraform-provider-yandex_${TERRAFORM_PROVIDER_VERSION}_linux_amd64.zip

FROM alpine:latest

ARG TERRAFORM_PROVIDER_VERSION=0.47.0
COPY --from=builder /tmp/terraform /usr/local/bin
COPY --from=builder /tmp/terraform-provider-yandex_v${TERRAFORM_PROVIDER_VERSION}_x4 /usr/local/bin
CMD ["terraform"]


  

