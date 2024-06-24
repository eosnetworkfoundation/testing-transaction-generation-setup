#!/usr/bin/env bash

LINES_BACK=${1:-100}
RAW=${2:-NO}

if [ $RAW == "NO" ]; then
    tail -${LINES_BACK} log/nodeos.log | grep "\[TRX_TRACE\] Speculative execution is" | grep '\{"id"\:' | cut -d':' -f5- | jq '{block_num: .block_num, receipt: .receipt, authorization: .action_traces[].act.authorization[].actor}'
else
    tail -${LINES_BACK} log/nodeos.log | grep "\[TRX_TRACE\] Speculative execution is" | grep '\{"id"\:'
fi
