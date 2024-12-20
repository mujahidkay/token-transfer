# Token Transfer Tool

A simple, scripted tool to transfer funds between an agoric local chain and testnets using [Cosmos Relayer](https://github.com/cosmos/relayer).

## Prerequisites

Ensure that you have a local chain running. See [Getting Started](https://docs.agoric.com/guides/getting-started/) to boot up a local chain instance using Docker.

Exec into the container:
```
docker exec -it <container_name_or_hash> /bin/bash
```

And send some funds to a local address (say `user1`):
```
agd tx --keyring-backend=test bank send validator agoric1rwwley550k9mmk6uq6mm6z4udrg8kyuyvfszjk 20000000uist --from=provision --chain-id=agoriclocal --yes
```
Change the FUND amount/denom as per need (and availability).

Next, fund your remote account via a faucet. For example, for ollinet, fund the gov1 account using https://ollinet.faucet.agoric.net/ with some toy bld/ibc tokens.

## Usage

The Makefile contains all the relevant targets to use the tool. You need to set the following environment variables (defaults are provided for most):
```
INTERNAL_KEY ?= user1
INTERNAL_CHAIN_NAME ?= agoric
INTERNAL_MNEMONIC ?= "spike siege world rather ordinary upper napkin voice brush oppose junior route trim crush expire angry seminar anchor panther piano image pepper chest alone"
EXTERNAL_KEY ?= gov1
EXTERNAL_MNEMONIC := ""
EXTERNAL_CHAIN_NAME ?= ollinet
EXTERNAL_CHAIN_RPC ?= ""
EXTERNAL_CHAIN_ID ?= ""
```
This tool uses existing addresses for transfering tokens and therefore, it needs both the keys and mnemonics to recover those addresses. Replace EXTERNAL_KEY, EXTERNAL_MNEMONIC and EXTERNAL_CHAIN_NAME with the respective values for the remote chain. EXTERNAL_MNEMONIC is required - others are optional and will default to ollinet values.

Run the following command to build and run the container:
```
make all
```

You can use `make exec` to exec into the container and play around if needed. Wait for a few seconds to have the links set up and relayer running. 
Run the following commands to log channel and address info to the console:
```
make show-addresses
make show-channels
```

Next, use the `make transfer` command to perform a transfer of funds:
```
make transfer FROM=<src_chain_name> TO=<target_chain_name> FUNDS=<amount_with_denom> ADDR=<target_address> CHANNEL=<channel_id> RELAYER_PATH=<relayer_path>"
```

Replace `<target_address>` with the target address printed via `make show-addresses` and `<channel_id>` with the appropriate channel id. The FROM, TO, FUNDS, and REPLAYER_PATH use default values from the Makefile - which assumes a local to remote (internal to external) transfer. TRANSFER_EXT_CHANNEL_ID should be used when sending funds from local to remote and TRANSFER_INT_CHANNEL_ID should be used when sending funds from remote to local. The FROM and TO values also need to be swapped accordingly. 

Examples:
```
make transfer FROM=agoric TO=ollinet FUNDS=10000ubld ADDR=agoric1rwwley550k9mmk6uq6mm6z4udrg8kyuyvfszjk CHANNEL=channel-4 PATH=agoric-ollinet
```
For the other way around, it becomes:
```
make transfer FROM=ollinet TO=agoric FUNDS=10000ubld ADDR=agoric1ldmtatp24qlllgxmrsjzcpe20fvlkp448zcuce CHANNEL=channel-151 PATH=agoric-ollinet  
```