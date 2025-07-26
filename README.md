## Description
This repository is designed to provide an easy way to create your own image
for Banana Pi F3 based on Yocto Project.

## Getting started

### Get submodules
```sh
git submodule init
git submodule update
```

### Create build environment
```sh
docker build --build-arg=uid=$(id -u) --build-arg=gid=$(id -g) -t bananapi-builder .
docker run -v $(pwd):/home/builder/poky -it bananapi-builder:latest
```

### Add custom layers and start building image
```sh
source oe-init-build-env
bitbake-layers add-layer ../../meta-riscv
bitbake-layers add-layer ../../meta-bananapi-f3
bitbake bananapi-f3-image
```
