#!/bin/sh
set -eu
NETWORK=${1:-mainnet} # This sets a default value of "mainnet" if no argument is provided
L1= # This is the L1 RPC endpoint
OP_NODE_L2_ENGINE_AUTH_RAW=e40d7f3f9836d2d7ed53b3f67954f8a3dae937b0ca112d059f8c56ba433a4ff1
OP_NODE_L2_ENGINE_AUTH=/tmp/engine-auth-jwt

if [ $NETWORK = "testnet" ]; then
 NETWORKVER=goerli
 OP_NODE_L2_ENGINE_RPC=http://geth:8550
  NODEL1=$L1:8544
else
 NETWORKVER=mainnet
 OP_NODE_L2_ENGINE_RPC=http://geth:8551
 NODEL1=$L1:8545
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
  --l1=$NODEL1 \
  --l2=$OP_NODE_L2_ENGINE_RPC \
  --log.level=info \
  --log.format=logfmt
