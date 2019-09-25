#!/bin/bash

echo " "
echo " "
echo " "
echo "This script will setup SSH keys"
echo " "
echo "There are 2 options:"
echo " - a SSH private key availabe in ENV_VAR_SSH_PRIVATE_KEY ( insecure, not recommended)"
echo " -(picked) an account with https://krypt.co ( more secure)"
echo " "
read -p -r "Press enter to continue or Control-C( ^C ) to quit without any setup"

# Ensure SSH is setup
SSH_PATH="$HOME/.ssh"
mkdir -p "$SSH_PATH"
chmod 700 "$SSH_PATH"

# Scan GitHub to eliminate manual step
touch "$SSH_PATH/known_hosts"
ssh-keyscan github.com >> ~/.ssh/known_hosts
chmod 600 "$SSH_PATH/known_hosts"

# Start SSH Aagent
eval $(ssh-agent)

echo "Starting Krypt.co pairing..."
echo "If already paired, just choose N"
kr pair --name "gitpod-$GITPOD_WORKSPACE_ID-$GITPOD_GIT_USER_EMAIL-$GITPOD_REPO_ROOT-$GITPOD_HOST"

kr sshconfig

echo " "
echo " "
echo " "
