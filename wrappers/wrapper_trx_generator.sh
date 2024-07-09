#!/usr/bin/env bash

set -x
WALLET_DIR=${HOME}/eosio-wallet
BUILD_TEST_DIR=/eosnetworkfoundation/spring_build/tests
TRX_LOG_DIR=/eosnetworkfoundation/log/trx_generator

HTTP_URL="http://127.0.0.1:8888"
P2P_HOST="127.0.0.1"
if [ -z $HTTP_URL ] || [ -z $P2P_HOST ]; then
  echo "must supply two arguments the HTTP URL and the P2P Host"
  exit 127
fi
PEER2PEERPORT="1444"
GENERATORID=0
ACCOUNTS=("$@")
PRIVKEYS=()

unset COMMA_SEP_ACCOUNTS
unset COMMA_SEP_KEYS

# setup wallets, open wallet, add keys if needed
[ ! -d "$WALLET_DIR" ] && mkdir -p "$WALLET_DIR"
if [ ! -f "${WALLET_DIR}"/load-test.wallet ]; then
  cleos wallet create --name load-test --file "${WALLET_DIR}"/load-test.pw
fi
IS_WALLET_OPEN=$(cleos wallet list | grep load-test | grep -F '*' | wc -l)
# not open then it is locked so unlock it
if [ $IS_WALLET_OPEN -lt 1 ]; then
  cat "${WALLET_DIR}"/load-test.pw | cleos wallet unlock --name load-test --password
fi


for name in "${ACCOUNTS[@]}"; do
  [ ! -s "$WALLET_DIR/${name}.keys" ] && cleos create key --to-console > "$WALLET_DIR/${name}.keys"
  PRIVKEYS+=($(grep Private "$WALLET_DIR/${name}.keys" | head -1 | cut -d: -f2 | sed 's/ //g'))
  cleos wallet import --name load-test --private-key ${PRIVKEYS[-1]}
  COMMA_SEP_ACCOUNTS+="${name},"
done
COMMA_SEP_ACCOUNTS=${COMMA_SEP_ACCOUNTS%,}

for key in "${PRIVKEYS[@]}"; do
  COMMA_SEP_KEYS+="${key},"
done
COMMA_SEP_KEYS=${COMMA_SEP_KEYS%,}

[ ! -d $TRX_LOG_DIR ] && mkdir $TRX_LOG_DIR

CHAIN_ID=$(cleos --url $HTTP_URL get info | grep chain_id | cut -d:  -f2 | sed 's/[ ",]//g')
LIB_ID=$(cleos --url $HTTP_URL get info | grep last_irreversible_block_id | cut -d:  -f2 | sed 's/[ ",]//g')
sleep 3
${BUILD_TEST_DIR}/trx_generator/trx_generator --generator-id $GENERATORID \
     --chain-id $CHAIN_ID \
     --target-tps 5 \
     --trx-expiration 6 \
     --contract-owner-account eosio.token \
     --abi-file /eosnetworkfoundation/repos/reference-contracts/build/contracts/eosio.token/eosio.token.abi \
     --actions-auths "{\"${ACCOUNTS[0]}\":\"${PRIVKEYS[0]}\"}" \
     --actions-data  "[{\"actionAuthAcct\":\"${ACCOUNTS[0]}\", \"actionName\":\"transfer\", \"actionData\":{\"from\":\"${ACCOUNTS[0]}\",\"to\":\"${ACCOUNTS[1]}\",\"quantity\":\"0.0001 EOS\",\"memo\":\"Transfer everything slowly\"}, \"actionAuthAcct\":\"${ACCOUNTS[0]}\", \"authorization\":{\"actor\":\"${ACCOUNTS[0]}\", \"permission\":\"active\"}} ]" \
     --accounts $COMMA_SEP_ACCOUNTS \
     --priv-keys $COMMA_SEP_KEYS \
     --last-irreversible-block-id $LIB_ID \
     --log-dir $TRX_LOG_DIR \
     --peer-endpoint-type p2p \
     --peer-endpoint $P2P_HOST \
     --port $PEER2PEERPORT
