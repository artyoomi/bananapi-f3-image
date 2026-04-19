## Description
This repository is designed to provide an easy way to create your own image
for Banana Pi F3 based on Yocto Project.

## Getting started

### Prerequisites
1. Docker installed
2. Docker Compose installed
3. Current user added to docker group (or you can patch wrapper.sh, if you want)

### Get submodules
```sh
git submodule init
git submodule update
```

### Setup proxy
If you need so, you can setup proxy by adding vless.conf to xray-tproxy folder.
You can read more into xray-tproxy/README.md.

### Create build environment
To create build environment you need to execute following script
```sh
./wrapper.sh
source oe-init-build-env
bitbake-layers add-layer ../../meta-bananapi-f3/
bitbake-layers add-layer ../../meta-riscv/
# Edit MACHINE variable in conf/local.conf to "bananapi-f3"
bitbake bananapi-f3-image
```
it will create Podman container with all dependencies needed to build Yocto
project.

### Future changes
1. Support of commands like bitbake.sh, devtool.sh and so on. They will
automatically setup build invironment inside of container and run your commands.
wrapper.sh is temporary solution;
2. Automatic addition of support layers meta-riscv and meta-bananapi-f3 in
build.
