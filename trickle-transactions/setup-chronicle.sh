#!/usr/bin/env bash

totalMem=$(grep MemTotal /proc/meminfo | cut -d:  -f2 | sed 's/ kB//')
trueNPROC=$(echo $totalMem / 1024 / 1024 / 3.2 | bc)

mkdir -p /eosnetworkfoundation/repos/
cd /eosnetworkfoundation/repos/ || exit
git clone --recursive https://github.com/EOSChronicleProject/eos-chronicle.git
cd eos-chronicle || exit
sudo ./pinned_build/install_deps.sh
mkdir build && \
 nice ./pinned_build/chronicle_pinned_build.sh /eosnetworkfoundation/repos/chronicle-deps /eosnetworkfoundation/repos/eos-chronicle/build $trueNPROC

# now setup nodejs monitoring agent
sudo apt install -y mariadb-server mariadb-client
cd /eosnetworkfoundation || exit
mkdir node-build && cd node-build || exit
curl -sL https://deb.nodesource.com/setup_20.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt-get install nodejs -y

cd /eosnetworkfoundation || exit
git clone https://github.com/EOSChronicleProject/chronicle-consumer-npm-examples.git
cd chronicle-consumer-npm-examples/token_transfers || exit
npm install
