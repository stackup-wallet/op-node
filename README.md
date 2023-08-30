# Optimism-setup

## To run the project locally

1. Clone the repo

2. Download the snapshots from these links:
    - [OpMainnet](https://datadirs.optimism.io/mainnet-bedrock.tar.zst)
    - [OpGoerli](https://datadirs.optimism.io/goerli-bedrock-archival-2023-07-29.tar.zst.)
    - you may want to use aria2 to download the snapshots faster
    - e.g ```aria2c -x6 -s6 -c --auto-file-renaming=false --max-tries=100 https://datadirs.optimism.io/goerli-bedrock.tar.zst```
    
3. Create a folder named datadir_mainnet or datadir_testnet in the root of the project and extract the snapshots in the respective folders like so `tar xvf ~/*whatever the name of the snapshot is.tar`

4. Make sure to change the L1 address to the proper address in `op-node-entrypoint`

5. Run `make start-optimism-mainnet` for mainnet and `make start-optimism-goerli` for testnet
