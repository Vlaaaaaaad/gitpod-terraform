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
  zsh zsh-common \
  kr software-properties-common dirmngr apt-transport-https \
  && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Install tools as user
USER gitpod
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install latest Terraform with tfenv for easier management
RUN git clone  --depth 1 \
    https://github.com/tfutils/tfenv.git \
    "$HOME/.tfenv"
ENV PATH="$HOME/.tfenv/bin:$PATH"
RUN tfenv install latest

# Install latest tflint
RUN curl -sSL https://raw.githubusercontent.com/wata727/tflint/master/install_linux.sh | sh

# Install pre-commit for automated checks
RUN pip3 install pre-commit

# Install latest terraform-docs
ENV GO_VERSION=1.12 \
    GOPATH=$HOME/go-packages \
    GOROOT=$HOME/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH
RUN go get github.com/segmentio/terraform-docs

# Set zsh config by appending to default one
RUN git clone --depth 1 \
      https://github.com/zsh-users/zsh-syntax-highlighting \
      "$HOME/.zsh-syntax-highlighting"
RUN git clone --depth 1 \
      https://github.com/zsh-users/zsh-history-substring-search \
      "$HOME/.zsh-history-substring-search"

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
#  revert back to default shell
#  adding Gitpod Layer will fail otherwise
SHELL ["/bin/sh", "-c"]
