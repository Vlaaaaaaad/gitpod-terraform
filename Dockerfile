# Big image but it's cached on gitpod nodes already
FROM gitpod/workspace-full:latest

ARG VENDOR
ARG BUILD_DATE
ARG GIT_REPO
ARG VCS_REF
ARG VERSION
ARG TITLE="gitpod-terraform"
ARG DESCRIPTION="Gitpod.io image for Terraform module development"
ARG DOCUMENTATION
ARG AUTHOR
ARG LICENSE="MIT"
LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.url="${GIT_REPO}" \
      org.opencontainers.image.source="${GIT_REPO}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.vendor="${VENDOR}" \
      org.opencontainers.image.title="${TITLE}" \
      org.opencontainers.image.description="${DESCRIPTION}" \
      org.opencontainers.image.documentation="${DOCUMENTATION}" \
      org.opencontainers.image.authors="${AUTHOR}" \
      org.opencontainers.image.licenses="${LICENSE}"

USER root

# Install zsh and krypt.co
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
                --recv-keys C4A05888A1C4FA02E1566F859F2A29A569653940 \
  && add-apt-repository "deb http://kryptco.github.io/deb kryptco main" \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
  kr software-properties-common dirmngr apt-transport-https \
  build-essential curl file git \
  && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Install tools as user
USER gitpod
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install helper tools
RUN brew install \
    zsh zsh-completions zsh-history-substring-search zsh-syntax-highlighting \
    awk pre-commit tfenv terraform-docs tflint \
    && brew cleanup
RUN tfenv install latest

# Set zsh config by appending to default one
COPY .gitpod.zshrc .
RUN cat .gitpod.zshrc >> "$HOME/.zshrcnew" \
    && cat "$HOME/.zshrc" >> "$HOME/.zshrcnew" \
    && mv "$HOME/.zshrcnew" "$HOME/.zshrc"

# Set bash config by appending to default one
COPY .gitpod.bashrc .
RUN cat .gitpod.bashrc >> "$HOME/.bashrcnew" \
  && cat "$HOME/.bashrc" >> "$HOME/.bashrcnew" \
  && mv "$HOME/.bashrcnew" "$HOME/.bashrc"

# Copy the helper scripts
COPY helpers "$HOME/helpers/"

# Give back control
USER root
#  but after making helpers executable
RUN chmod +x "$HOME/helpers/"*.sh
#  and revert back to default shell
#  otherwise adding Gitpod Layer will fail
SHELL ["/bin/sh", "-c"]
