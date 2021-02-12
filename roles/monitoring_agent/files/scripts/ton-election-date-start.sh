#!/bin/bash -eE

# export ton environments
. ton-env.sh

ton-check-env.sh TON_CLI
ton-check-env.sh TON_DAPP


# get elector address
ELECTOR_ADDR="-1:$($TON_CLI --url $TON_DAPP  getconfig 1 | grep 'p1:' | sed 's/Config p1:[[:space:]]*//g' | tr -d \")"

# get elector start (unixtime)
ELECTIONS_START=$($TON_CLI --url $TON_DAPP runget $ELECTOR_ADDR active_election_id  | grep 'Result:' | sed 's/Result:[[:space:]]*//g' | tr -d \"[])

if (( $ELECTIONS_START == 0 ));
    then
        echo "-1";
        exit
fi

ELECTOR_CONFIG=`$TON_CLI --url $TON_DAPP getconfig 15` 
ELECTOR_CONFIG_JSON=$(echo $ELECTOR_CONFIG | awk '{split($0, a, "p15:"); print a[2]}')
ELECTOR_CONFIG_ELECTIONS_START_BEFORE=`echo "$ELECTOR_CONFIG_JSON" | jq ".elections_start_before"`

echo $(($ELECTIONS_START - $ELECTOR_CONFIG_ELECTIONS_START_BEFORE))
