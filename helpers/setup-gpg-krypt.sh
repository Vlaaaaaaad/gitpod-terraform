#!/bin/bash

echo " "
echo " "
echo " "
echo "This script will setup GPG keys"
echo " "
echo "There are 2 options:"
echo " - a GPG private key availabe in ENV_VAR_GPG_PRIVATE_KEY ( insecure, not recommended)"
echo " -(picked) an account with https://krypt.co ( more secure)"
echo " "
read -p -r "Press enter to continue or Control-C( ^C ) to quit without any setup"

echo "Starting Krypt.co pairing..."
echo "If already paired, just choose N"
kr pair --name "gitpod-$GITPOD_WORKSPACE_ID-$GITPOD_GIT_USER_EMAIL-$GITPOD_REPO_ROOT-$GITPOD_HOST" || true

kr codesign

echo " "
echo " "
echo " "
