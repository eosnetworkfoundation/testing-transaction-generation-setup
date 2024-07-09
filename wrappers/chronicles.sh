#!/usr/bin/env bash

# dirs for irreverisble
mkdir -p chronicle/irr
mkdir -p chronicle/irr/data
mkdir -p chronicle/irr/config
# dirs for head blocks
mkdir -p chronicle/head
mkdir -p chronicle/head/data
mkdir -p chronicle/head/config

# irreversible config
cat > chronicle/irr/config/config.ini << EOFA
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
EOFA
# head config
cat > chronicle/head/config/config.ini << EOFA
host = 127.0.0.1
port = 8080
mode = scan
plugin = exp_ws_plugin
exp-ws-host = 127.0.0.1
exp-ws-port = 8855
exp-ws-bin-header = true
skip-block-events = true
exp-ws-max-unack = 200
skip-table-deltas = yes
EOFA

# get up to speed playback history
/usr/local/sbin/chronicle-receiver --config-dir=/eosnetworkfoundation/chronicle/irr/config \
   --data-dir=/eosnetworkfoundation/chronicle/irr/data \
   --host=127.0.0.1 --port=8080 \
   --start-block=1 --mode=scan-noexport --end-block=5000000

/usr/local/sbin/chronicle-receiver --config-dir=/eosnetworkfoundation/chronicle/head/config \
    --data-dir=/eosnetworkfoundation/chronicle/head/data \
    --host=127.0.0.1 --port=8080 \
    --start-block=1 --mode=scan-noexport --end-block=5000000

# start observer
nohup /usr/local/sbin/chronicle-receiver \
   --config-dir=/eosnetworkfoundation/chronicle/head/config --data-dir=/eosnetworkfoundation/chronicle/head/data &

nohup /usr/local/sbin/chronicle-receiver \
  --config-dir=/eosnetworkfoundation/chronicle/irr/config --data-dir=/eosnetworkfoundation/chronicle/irr/data &
