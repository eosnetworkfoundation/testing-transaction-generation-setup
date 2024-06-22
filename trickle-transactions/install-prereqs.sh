#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y \
        build-essential \
        cmake \
        git \
        libcurl4-openssl-dev \
        libgmp-dev \
        llvm-11-dev \
        python3-numpy \
        file \
        zlib1g-dev \
        jq  \
        gdb \
        vim

sudo mkdir -p /eosnetworkfoundation


# sudo fdisk /dev/nvme1n1
# g - create partition table
# n - new partition
# w - write it
# q - exit / quit
sudo mkfs.ext4 /dev/nvme1n1p1
sudo mount /dev/nvme1n1p1 /eosnetworkfoundation/
sudo chown ubuntu:ubuntu /eosnetworkfoundation/
