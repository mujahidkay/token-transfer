.PHONY: build run exec

IMAGE_NAME = cosmos-relayer
CONTAINER_NAME = cosmos-relayer-container

INTERNAL_KEY ?= user1
INTERNAL_MNEMONIC ?= "spike siege world rather ordinary upper napkin voice brush oppose junior route trim crush expire angry seminar anchor panther piano image pepper chest alone"
INTERNAL_CHAIN_NAME ?= agoric
EXTERNAL_KEY ?= gov1
EXTERNAL_MNEMONIC := ""
EXTERNAL_CHAIN_NAME ?= ollinet
EXTERNAL_CHAIN_RPC ?= ""
EXTERNAL_CHAIN_ID ?= "" 

build:
	docker build -t $(IMAGE_NAME) .

run:
ifeq ($(strip $(EXTERNAL_MNEMONIC)),)
	@echo "Error: EXTERNAL_MNEMONIC is not set"
	@exit 1
endif
	@docker run -d --name $(CONTAINER_NAME) --network host \
		-e INTERNAL_KEY=$(INTERNAL_KEY) \
		-e INTERNAL_MNEMONIC=$(INTERNAL_MNEMONIC) \
		-e INTERNAL_CHAIN_NAME=$(INTERNAL_CHAIN_NAME) \
		-e EXTERNAL_KEY=$(EXTERNAL_KEY) \
		-e EXTERNAL_MNEMONIC=$(EXTERNAL_MNEMONIC) \
		-e EXTERNAL_CHAIN_NAME=$(EXTERNAL_CHAIN_NAME) \
		-e EXTERNAL_CHAIN_RPC=$(EXTERNAL_CHAIN_RPC) \
		-e EXTERNAL_CHAIN_ID=$(EXTERNAL_CHAIN_ID) \
		$(IMAGE_NAME)

exec:
	@docker exec -it $(CONTAINER_NAME) /bin/bash

stop:
	docker stop $(CONTAINER_NAME)

clean: stop
	docker rm $(CONTAINER_NAME)

show-channels:
	@docker exec $(CONTAINER_NAME) /bin/bash -c '\
		TRANSFER_EXT_CHANNEL_ID=$$(relayer q channels ${INTERNAL_CHAIN_NAME} ${EXTERNAL_CHAIN_NAME} | jq -r '.channel_id' | sort -t_ -k2 -n | tail -n 1); \
		TRANSFER_INT_CHANNEL_ID=$$(relayer q channels ${INTERNAL_CHAIN_NAME} ${EXTERNAL_CHAIN_NAME} | jq -r '.counterparty.channel_id' | sort -t_ -k2 -n | tail -n 1); \
		echo "Channel IDs set: TRANSFER_EXT_CHANNEL_ID=$$TRANSFER_EXT_CHANNEL_ID, TRANSFER_INT_CHANNEL_ID=$$TRANSFER_INT_CHANNEL_ID"'

show-all-channels:
	docker exec $(CONTAINER_NAME) /bin/bash -c '\
		relayer q channels ${INTERNAL_CHAIN_NAME} ${EXTERNAL_CHAIN_NAME}'

show-addresses:
	@docker exec $(CONTAINER_NAME) /bin/bash -c '\
		echo "===============Internal Chain Addresses==============="; \
		relayer q balance ${INTERNAL_CHAIN_NAME}; \
		echo "======================================================"; \
		echo "===============External Chain Addresses==============="; \
		relayer q balance ${EXTERNAL_CHAIN_NAME}; \
		echo "======================================================"'

FROM=${INTERNAL_CHAIN_NAME}
TO=${EXTERNAL_CHAIN_NAME}
FUNDS=100000ubld
RELAYER_PATH=${INTERNAL_CHAIN_NAME}-${EXTERNAL_CHAIN_NAME}
transfer:
ifeq ($(and $(CHANNEL),$(ADDR)),)
	@echo "Error: CHANNEL and ADDR argument is required. Usage: make transfer FROM=<src_chain_name> TO=<target_chain_name> FUNDS=<amount_with_denom> ADDR=<target_address> CHANNEL=<channel_id> RELAYER_PATH=<relayer_path>"
	@exit 1
endif
	docker exec ${CONTAINER_NAME} /bin/bash -c '\
		relayer transact transfer ${FROM} ${TO} ${FUNDS} ${ADDR} ${CHANNEL} --path ${RELAYER_PATH}'

all: build run
