#!/bin/bash
set -o errexit -o errtrace

# Ensure required environment variables are set
if [ -z "$INTERNAL_KEY" ] || [ -z "$INTERNAL_MNEMONIC" ] || [ -z "$EXTERNAL_KEY" ] || [ -z "$EXTERNAL_MNEMONIC" ]; then
    echo "Error: INTERNAL_KEY, INTERNAL_MNEMONIC, EXTERNAL_KEY, and EXTERNAL_MNEMONIC must be set"
    exit 1
fi

INTERNAL_CHAIN_ADDRESS_PREFIX=${INTERNAL_CHAIN_ADDRESS_PREFIX:-agoric}
INTERNAL_CHAIN_GAS_DENOM=${INTERNAL_CHAIN_GAS_DENOM:-uist}
INTERNAL_CHAIN_ID=${INTERNAL_CHAIN_ID:-agoriclocal}
INTERNAL_CHAIN_NAME=${INTERNAL_CHAIN_NAME:-agoric}
INTERNAL_CHAIN_RPC="http://host.docker.internal:26657"
EXTERNAL_CHAIN_ADDRESS_PREFIX=${EXTERNAL_CHAIN_ADDRESS_PREFIX:-agoric}
EXTERNAL_CHAIN_GAS_DENOM=${EXTERNAL_CHAIN_GAS_DENOM:-ubld}
EXTERNAL_CHAIN_ID=${EXTERNAL_CHAIN_ID:-agoric-mainfork-1}
EXTERNAL_CHAIN_NAME=${EXTERNAL_CHAIN_NAME:-ollinet}
EXTERNAL_CHAIN_RPC="https://ollinet.rpc.agoric.net:443"
RELAYER_PATH="$INTERNAL_CHAIN_NAME-$EXTERNAL_CHAIN_NAME"

HOME_PATH=${HOME_PATH:-/root/.relayer/config}

replace_placeholders_in_config_files() {
    sed "$HOME_PATH/internal-chain-config.json" \
     --expression="s/\\\$INTERNAL_CHAIN_ADDRESS_PREFIX/${INTERNAL_CHAIN_ADDRESS_PREFIX}/g" \
     --expression="s/\\\$INTERNAL_CHAIN_GAS_DENOM/${INTERNAL_CHAIN_GAS_DENOM}/g" \
     --expression="s/\\\$INTERNAL_CHAIN_ID/${INTERNAL_CHAIN_ID}/g" \
     --expression="s|\\\$INTERNAL_CHAIN_RPC|${INTERNAL_CHAIN_RPC}|g" \
     --in-place \
     --regexp-extended
    sed "$HOME_PATH/external-chain-config.json" \
     --expression="s/\\\$EXTERNAL_CHAIN_ADDRESS_PREFIX/${EXTERNAL_CHAIN_ADDRESS_PREFIX}/g" \
     --expression="s/\\\$EXTERNAL_CHAIN_GAS_DENOM/${EXTERNAL_CHAIN_GAS_DENOM}/g" \
     --expression="s/\\\$EXTERNAL_CHAIN_ID/${EXTERNAL_CHAIN_ID}/g" \
     --expression="s|\\\$EXTERNAL_CHAIN_RPC|${EXTERNAL_CHAIN_RPC}|g" \
     --in-place \
     --regexp-extended
}

init_relayer() {
    relayer config init
}

add_chains() {
    relayer chains add "$INTERNAL_CHAIN_NAME" --file $HOME_PATH/internal-chain-config.json
    relayer chains add "$EXTERNAL_CHAIN_NAME" --file $HOME_PATH/external-chain-config.json
}

restore_keys() {
    relayer keys restore "$INTERNAL_CHAIN_NAME" "$INTERNAL_KEY" "$INTERNAL_MNEMONIC" --coin-type 564
    relayer keys restore "$EXTERNAL_CHAIN_NAME" "$EXTERNAL_KEY" "$EXTERNAL_MNEMONIC" --coin-type 564
}

use_keys() {
    relayer keys use "$INTERNAL_CHAIN_NAME" "$INTERNAL_KEY"
    relayer keys use "$EXTERNAL_CHAIN_NAME" "$EXTERNAL_KEY"
}

add_path() {
    relayer paths new "$INTERNAL_CHAIN_ID" "$EXTERNAL_CHAIN_ID" "$RELAYER_PATH"
    relayer transact link "$RELAYER_PATH" --override
}

start_relayer() {
    relayer start
}

init_relayer
replace_placeholders_in_config_files
add_chains
restore_keys
use_keys
add_path
start_relayer