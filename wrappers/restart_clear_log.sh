#!/usr/bin/env bash

# kill of running nodoes
MY_ID=$(id -u)
for p in $(ps -u $MY_ID | grep nodeos | sed -e 's/^[[:space:]]*//' | cut -d" " -f1); do
  echo $p && kill -15 $p
  sleep 1
done

# rotate log
DATE=$(date +%j%H%M%S)
zstd /eosnetworkfoundation/log/nodeos.log -o /eosnetworkfoundation/log/nodeos-${DATE}.log.zst
:> /eosnetworkfoundation/log/nodeos.log

# startup
sleep 1
# shellcheck disable=SC2046
/eosnetworkfoundation/testing-transaction-generation-setup/trickle-transactions/run-peer.sh $(cat /eosnetworkfoundation/config/peers.txt)
