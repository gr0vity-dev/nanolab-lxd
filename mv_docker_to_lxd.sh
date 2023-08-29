#!/bin/bash

#  gr0vity : 2023-08
#  Copy over a local docker image to lxd container (nanolab22 by default)

# Defaults
DOCKER_IMAGE=""
LXD_CONTAINER="nanolab22"
IMAGE_TAR="my_image.tar"

# Check if at least one argument (Docker image name) is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 docker_image_name [lxd_container_name]"
    exit 1
else
    DOCKER_IMAGE="$1"
fi

# Check if the optional LXD container name is provided
if [ "$#" -eq 2 ]; then
    LXD_CONTAINER="$2"
fi

# Save the Docker image to a tarball
docker save -o ${IMAGE_TAR} ${DOCKER_IMAGE}

# Push the tarball to the LXD container
lxc file push ${IMAGE_TAR} ${LXD_CONTAINER}/root/

# Load the Docker image inside the LXD container and then cleanup
lxc exec ${LXD_CONTAINER} -- /bin/bash -c "docker load -i /root/${IMAGE_TAR} && rm /root/${IMAGE_TAR}"

# Remove the tarball from host
rm ${IMAGE_TAR}

echo "Docker image ${DOCKER_IMAGE} transferred and loaded into ${LXD_CONTAINER}."
