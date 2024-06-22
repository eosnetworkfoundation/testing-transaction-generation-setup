#!/usr/bin/env bash

curl -X POST http://127.0.0.1:8888/v1/producer/create_snapshot > /eosnetworkfoundation/data/snapshots/snap.json
hb_num=$(jq .head_block_num /eosnetworkfoundation/data/snapshots/snap.json)
mv /eosnetworkfoundation/data/snapshots/snap.json /eosnetworkfoundation/data/snapshots/snap-${hb_num}.json
