#!/bin/sh
set -eu
NETWORK=${1:-mainnet} # This sets a default value of "mainnet" if no argument is provided
L1= # This is the L1 RPC endpoint

if [ $NETWORK = "testnet" ]; then
 NETWORKVER=goerli
 OP_NODE_L2_ENGINE_RPC=http://geth:8550
else
 NETWORKVER=mainnet
 OP_NODE_L2_ENGINE_RPC=http://geth:8551
fi

# wait until local geth comes up (authed so will return 401 without token)
until [ "$(curl -s -w '%{http_code}' -o /dev/null "$OP_NODE_L2_ENGINE_RPC")" -eq 401 ]; do
  echo "waiting for geth to be ready"
  sleep 5
done

# public-facing P2P node, advertise public IP address
PUBLIC_IP=$(curl -s v4.ident.me)
export OP_NODE_P2P_ADVERTISE_IP=$PUBLIC_IP

echo "$OP_NODE_L2_ENGINE_AUTH_RAW" > "$OP_NODE_L2_ENGINE_AUTH"

exec ./op-node \
  --network=$NETWORKVER \
  --rpc.addr=0.0.0.0 \
  --rpc.port=8501 \
  --p2p.listen.ip=0.0.0.0 \
  --p2p.peers.lo=10 \
  --p2p.peers.hi=20 \
  --l1=$L1 \
  --l2=$OP_NODE_L2_ENGINE_RPC \
  --log.level=info \
  --log.format=logfmt
