#!/bin/sh

export ENV_SECTOR_SIZE=512MiB
export ENV_LOTUS_NODE_IP=192.168.16.100
export ENV_LOTUS_NODE_PORT=1234
export ENV_LOTUS_STORAGE_MINER_IP=$ENV_LOTUS_NODE_IP
export ENV_LOTUS_STORAGE_MINER_PORT=2345
export ENV_LOG_DIR=./log
ulimit -HSn 65536

export ENV_WORKSPACE=$HOME/workspace/filecoin-project
export ENV_LOTUS_ROOT=$ENV_WORKSPACE/lotus-
export ENV_LOTUS_REV=interop.6.8.1
export ENV_LOTUS_SRC_DIR=$ENV_LOTUS_ROOT$ENV_LOTUS_REV

export ENV_STORAGE_ROOT=/opt/data/filecoin
export ENV_LOTUS_ROOT=$ENV_STORAGE_ROOT/lotus
export ENV_FIL_PARAM_CACHE=$ENV_STORAGE_ROOT/filecoin-proof-parameters
export ENV_LOTUS_STORAGE_ROOT=$ENV_STORAGE_ROOT/lotusstorage
export ENV_LOTUS_TMP_DIR=$ENV_STORAGE_ROOT/lotustmpdir
export ENV_LOTUS_WORKER_DIR=$ENV_STORAGE_ROOT/lotusworker

##
## orig, ipfs, china
##
export ENV_PARAM_SOURCE=orig

source ./mach-ip.sh
