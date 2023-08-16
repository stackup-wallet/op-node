start-optimism-goerli:
	cd op-goerli && sudo docker-compose -f docker-compose-goerli.yml up -d

stop-optimism-goerli:
	cd op-goerli && sudo docker-compose -f docker-compose-goerli.yml down

start-optimism-mainnet:
	cd op-mainnet && sudo docker-compose -f docker-compose-mainnet.yml up -d

stop-optimism-mainnet:
	cd op-mainnet && sudo docker-compose -f docker-compose-mainnet.yml down
