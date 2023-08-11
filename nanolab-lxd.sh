#!/bin/bash

## This script assumes that lxd is installed on the host machine
## lxd can be installed by running the following commands :

# sudo apt-get install lxd-client
# lxd init

## (you can keep all defaults when doing the lxd init)


set -e  # Exit on any error

CONTAINER_NAME=${1:-nanolab22}

# Check if the nanolab storage pool exists
if ! lxc storage list | grep -q "nanolab"; then
    # Create dedicated nanolab storage in btrfs (required for docker)
    lxc storage create nanolab btrfs size=50GB
fi

# Launch the container using the nanolab storage pool
lxc init ubuntu:22.04 $CONTAINER_NAME -s nanolab
# Wait a bit for the container to start properly
sleep 10

lxc start $CONTAINER_NAME
# Execute the commands inside the container in a single `lxc exec` call
lxc exec $CONTAINER_NAME -- bash << EOL
# Update and install container dependencies
CONTAINER_DEPENDENCIES="ca-certificates curl gnupg lsb-release python3-pip build-essential net-tools apt-transport-https software-properties-common"
apt-get update
apt-get install -y \$CONTAINER_DEPENDENCIES

# Add Docker repository and install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io --yes


# Install docker-compose 1.29
curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install nanolab using pip3
pip3 install nanolab
EOL


#Set  security.nesting true to allow docker to run
lxc config set $CONTAINER_NAME security.nesting true


echo "Setup completed for container: $CONTAINER_NAME."