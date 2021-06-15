# Big image but it's cached on gitpod nodes already
FROM gitpod/workspace-full:latest

# Install tools as the gitpod user
USER gitpod
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install helper tools
RUN brew update && brew install \
    gawk coreutils pre-commit tfenv terraform-docs \
    tflint liamg/tfsec/tfsec instrumenta/instrumenta/conftest \
    && brew install --ignore-dependencies cdktf \
    && brew cleanup
RUN tfenv install latest && tfenv use latest

COPY .gitpod.bashrc /home/gitpod/.bashrc.d/custom

# Give back control
USER root
#  and revert back to default shell
#  otherwise adding Gitpod Layer will fail
SHELL ["/bin/sh", "-c"]
