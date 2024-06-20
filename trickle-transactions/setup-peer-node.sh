#!/usr/bin/env bash


# clone scripts
git clone https://github.com/eosnetworkfoundation/testing-transaction-generation-setup.git

# download install Spring software
TAG=release/1.0-beta2

# install and download spring
mkdir repos
cd repos || exit
git clone -b $TAG https://github.com/AntelopeIO/spring.git
cd spring
git pull
git submodule update --init --recursive
cd .. || exit

# create build dir
mkdir -p spring_build
cd spring_build || exit

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-11 ../repos/spring
make -j "$(nproc)" package

echo "about to call sudo"
set -x
sudo apt-get install -y ./spring_*.deb

# dir for nodeos
cd .. || exit
mkdir log data config
cp logging.json config
