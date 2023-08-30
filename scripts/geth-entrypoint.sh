#!/bin/sh
set -eu

NETWORK=${1:-mainnet} # This sets a default value of "mainnet" if no argument is provided
VERBOSITY=${GETH_VERBOSITY:-3}

if [ $NETWORK = "testnet" ]; then
 echo $NETWORK
 ROLLUP=https://goerli-sequencer.optimism.io/
 GETH_DATA_DIR=/home/ubuntu/datadir_testnet
 OP_NODE_L2_ENGINE_AUTH_RAW=e40d7f3f9836d2d7ed53b3f67954f8a3dae937b0ca112d059f8c56ba433a4ff1
 OP_NODE_L2_ENGINE_AUTH=/tmp/engine-auth-jwt
 AUTHRPC_PORT="${AUTHRPC_PORT:-8550}"
 CHAINID=420
 HTTP_PORT=8545
 WS_PORT=8546
 METRICS_PORT="${METRICS_PORT:-6060}"
else
 echo $NETWORK
 ROLLUP=https://mainnet-sequencer.optimism.io/
 GETH_DATA_DIR=/home/ubuntu/datadir_mainnet
 OP_NODE_L2_ENGINE_AUTH_RAW=e40d7f3f9836d2d7ed53b3f67954f8a3dae937b0ca112d059f8c56ba433a4ff1
 OP_NODE_L2_ENGINE_AUTH=/tmp/engine-auth-jwt
 AUTHRPC_PORT="${AUTHRPC_PORT:-8551}"
 CHAINID=10
 HTTP_PORT=8545
 WS_PORT=8546
 METRICS_PORT="${METRICS_PORT:-6061}"
fi

GETH_CHAINDATA_DIR="$GETH_DATA_DIR/geth/chaindata"
HOST_IP="0.0.0.0"
ADDITIONAL_ARGS=""

mkdir -p $GETH_DATA_DIR

echo "$OP_NODE_L2_ENGINE_AUTH_RAW" > "$OP_NODE_L2_ENGINE_AUTH"

if [ "${OP_GETH_ETH_STATS+x}" = x ]; then
  ADDITIONAL_ARGS="$ADDITIONAL_ARGS --ethstats=$OP_GETH_ETH_STATS"
fi

if [ "${OP_GETH_ALLOW_UNPROTECTED_TXS+x}" = x ]; then
	ADDITIONAL_ARGS="$ADDITIONAL_ARGS --rpc.allow-unprotected-txs=$OP_GETH_ALLOW_UNPROTECTED_TXS"
fi

echo $GETH_DATA_DIR

exec ./geth \
	--ws \
  --ws.port=$WS_PORT \
  --ws.addr=localhost \
  --ws.origins="*" \
  --http \
  --http.port=$HTTP_PORT \
  --http.addr=0.0.0.0 \
  --http.vhosts="*" \
  --http.corsdomain="*" \
  --http.api=personal,eth,net,web3,txpool,debug \
  --authrpc.addr=0.0.0.0 \
	--authrpc.jwtsecret="$OP_NODE_L2_ENGINE_AUTH" \
  --authrpc.port=$AUTHRPC_PORT \
  --authrpc.vhosts="*" \
  --datadir=$GETH_DATA_DIR \
  --verbosity=3 \
  --rollup.disabletxpoolgossip=true \
  --rollup.sequencerhttp=$ROLLUP \
  --metrics \
  --metrics.addr=0.0.0.0 \
  --metrics.port="$METRICS_PORT" \
  --nodiscover \
  --syncmode=full \
  --maxpeers=0 \
  --snapshot=false \
	$ADDITIONAL_ARGS # intentionally unquoted

