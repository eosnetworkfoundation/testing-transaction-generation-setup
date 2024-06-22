#!/usr/bin/env bash

cd /eosnetworkfoundation || exit
# clone scripts
git clone https://github.com/eosnetworkfoundation/testing-transaction-generation-setup.git

# download install Spring software
TAG=release/1.0-beta2

# install and download spring
mkdir repos
cd repos || exit
git clone -b $TAG https://github.com/AntelopeIO/spring.git
cd spring || exit
git pull
git submodule update --init --recursive
cd ../.. || exit

# create build dir
mkdir -p spring_build
cd spring_build || exit

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-11 ../repos/spring
totalMem=$(grep MemTotal /proc/meminfo | cut -d:  -f2 | sed 's/ kB//')
trueNPROC=$(echo $totalMem / 1024 / 1024 / 3.2 | bc)

make -j $trueNPROC package

echo "about to call sudo"
set -x
sudo apt-get install -y ./spring_*.deb
set +x

# dir for nodeos
cd .. || exit
mkdir log data config
cp testing-transaction-generation-setup/trickle-transactions/logging.json config
