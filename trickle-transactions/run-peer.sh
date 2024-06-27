#!/usr/bin/env bash


peers=("$@")

PEER_STRING=""
for element in "${peers[@]}";
do
    PEER_STRING="${PEER_STRING} --p2p-peer-address ${element}"
done

echo $PEER_STRING
nodeos --agent-name "Trickle Transactions" \
  --http-server-address 127.0.0.1:8888 \
  --p2p-listen-endpoint 0.0.0.0:1444 \
  --data-dir /eosnetworkfoundation/data \
  $PEER_STRING \
  --logconf /eosnetworkfoundation/config/logging.json  \
  --eos-vm-oc-enable 1 \
  --chain-state-db-size-mb 16000 \
  --verbose-http-errors \
  --allowed-connection any \
  --p2p-max-nodes-per-host 10 \
  --plugin eosio::chain_api_plugin \
  --plugin eosio::chain_plugin \
  --plugin eosio::http_plugin \
  --plugin eosio::producer_plugin \
  --plugin eosio::producer_api_plugin \
  --plugin eosio::net_plugin \
  --plugin eosio::net_api_plugin \
  --plugin eosio::db_size_api_plugin \
  --disable-replay-opts \
  --read-only-read-window-time-us 165000 \
  --read-only-write-window-time-us 50000 \
  > /eosnetworkfoundation/log/nodeos.log 2>&1 &
