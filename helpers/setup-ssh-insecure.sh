#!/bin/bash

echo " "
echo " "
echo " "
echo "This script will setup SSH keys"
echo " "
echo "There are 2 options:"
echo " -(picked) a SSH private key availabe in ENV_VAR_SSH_PRIVATE_KEY ( insecure, not recommended)"
echo " - an account with https://krypt.co ( more secure)"
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

echo "Something found in ENV_VAR_SSH_PRIVATE_KEY"
echo "Will attempt to use ENV_VAR_SSH_PRIVATE_KEY as a private key"
echo "THIS IS UNSAFE"

echo "$ENV_VAR_SSH_PRIVATE_KEY" > "$SSH_PATH/id_rsa"
chmod 600 "$SSH_PATH/id_rsa"
ssh-add "$SSH_PATH/id_rsa"

echo " "
echo " "
echo " "
