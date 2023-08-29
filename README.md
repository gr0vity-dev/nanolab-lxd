# NanoLab-LXD

NanoLab-LXD encapsulates the functionalities of NanoLab into an LXD container, offering a lightweight and efficient environment for running test cases against local networks of nano-nodes.

[NanoLab](https://github.com/gr0vity-dev/nanolab) is an easy-to-use testing tool designed to run test cases against a local network of nano-nodes.
The `nanolab-lxd` project takes the power of NanoLab and packages it within an LXD container for enhanced isolation and ease of use.

This README will guide you on setting up NanoLab within an LXD container.

## Prerequisites

### LXD Installation

LXD is a container manager for system containers. Before setting up NanoLab within LXD, you need to ensure that LXD is installed and initialized.

#### Ubuntu

```bash
sudo apt-get install lxd lxd-client
lxd init
```

#### Arch Linux

```bash
sudo pacman -S lxd
lxd init
```

#### RedHat / CentOS

```bash
sudo yum install lxd
lxd init
```

_For other distributions, please refer to their respective package management systems to install LXD. After installation, run `lxd init` to initialize LXD._

### Script Setup

1. Clone this repository and navigate to its directory.
2. Ensure the `nanolab-lxd.sh` script has execution permissions:

```bash
chmod +x nanolab-lxd.sh
```

## Usage

To set up NanoLab within an LXD container:

```bash
./nanolab-lxd.sh [container-name]
```

_Replace `[container-name]` with the desired name for your LXD container. If you don't provide a name, it defaults to `nanolab22`._

## What the Script Does

1. Checks for an LXD storage pool named "nanolab." If it doesn't exist, the script creates one.
2. Launches an LXD container using the Ubuntu 22.04 image.
3. Installs essential container dependencies.
4. Sets up Docker inside the container.
5. Installs docker-compose v1.29.
6. Installs NanoLab via pip3.

Once the script completes its execution, you'll have a fully functional NanoLab environment within an LXD container, ready for testing!

## Running a testcase from host inside lxd container
```bash
./run-lab-lxd list #shows all available testcases

./run-lab-lxd run -t flamegraph_bintree -i "nanocurrency/nano:V26.0DB13"
```

## Using local docker builds inside lxd container
- build the nano-docker image :
`docker build -f docker/node/Dockerfile  -t your_nano_image .`

```bash
./mv_docker_to_lxd.sh your_nano_image

./run-lab-lxd run -t flamegraph_bintree -i "your_nano_image"
```


## Copy over flamegraphs from lxc to host
```bash
./pull_flamegraphs.sh --rm
``` 
The --rm   flag is optional and removes the flamgraphs from teh lxd container after pulling them 

## Conclusion

Harness the power of NanoLab within an LXD container with the `nanolab-lxd` project. This setup streamlines the process of setting up a local test environment, ensuring reproducibility and isolation.

If you face any issues or have suggestions, please open an issue or a pull request.
