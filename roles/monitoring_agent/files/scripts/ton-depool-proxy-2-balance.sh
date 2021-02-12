#!/bin/bash -eE

# export ton environments
. ton-env.sh

ton-check-env.sh DEPOOL_ADDR
ton-check-env.sh TON_CONTRACT_DEPOOL_ABI
ton-check-env.sh TON_CLI
ton-check-env.sh TON_DAPP

DEPOOL_INFO=`$TON_CLI --url $TON_DAPP run "$DEPOOL_ADDR" getDePoolInfo {} --abi $TON_CONTRACT_DEPOOL_ABI`
DEPOOL_PROXY_1_ADDR=$(echo $DEPOOL_INFO | awk -F'Result: ' '{print $2}' | jq -r '.proxies[1]')

$TON_CLI --url $TON_DAPP  account $DEPOOL_PROXY_1_ADDR | grep 'balance:' | sed 's/balance:[[:space:]]*//g'