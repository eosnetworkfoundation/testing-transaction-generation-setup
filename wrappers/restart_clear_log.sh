#!/usr/bin/env bash

# kill of running nodoes
MY_ID=$(id -u)
for p in $(ps -u $MY_ID | grep nodeos | sed -e 's/^[[:space:]]*//' | cut -d" " -f1); do
  echo $p && kill -15 $p
  sleep 1
done

sleep 1
/eosnetworkfoundation/testing-transaction-generation-setup/trickle-transactions/run-peer.sh
