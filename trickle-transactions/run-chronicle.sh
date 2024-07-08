#!/bin/env bash

#SERVICE_NAME="BETA3SHIP"
if [ ! -d /eosnetworkfoundation/chronicle/config ]; then
  mkdir -p /eosnetworkfoundation/chronicle/config
fi
if [ ! -d /eosnetworkfoundation/chronicle/data ]; then
  mkdir -p /eosnetworkfoundation/chronicle/data
fi

cat > /eosnetworkfoundation/chronicle/config/config.ini << EOF
host = 127.0.0.1
port = 8080
mode = scan
plugin = exp_ws_plugin
exp-ws-host = 127.0.0.1
exp-ws-port = 8856
exp-ws-bin-header = true
skip-block-events = true
irreversible-only = true
exp-ws-max-unack = 200
skip-table-deltas = yes
EOF

/usr/local/sbin/chronicle-receiver \
  --config-dir=/eosnetworkfoundation/chronicle/config --data-dir=/eosnetworkfoundation/chronicle/data
