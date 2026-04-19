FROM ubuntu:22.04

# Dependencies, according to: https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    build-essential \
    chrpath \
    cpio \
    debianutils \
    diffstat \
    file \
    gawk \
    gcc \
    git \
    iputils-ping \
    libacl1 \
    liblz4-tool \
    locales \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pexpect \
    python3-pip \
    python3-subunit \
    socat \
    texinfo \
    unzip \
    vim \
    wget \
    xz-utils \
    zstd && \
    apt-get clean && \
    apt-get autoremove -y

# Set locale for build
RUN locale-gen en_US.UTF-8
