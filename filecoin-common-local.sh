#!/bin/bash

source ./mach-env.sh
mkdir -p $ENV_LOG_DIR

case $ENV_PARAM_SOURCE in
	china)
		export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"
		;;
	ipfs)
		export IPFS_GATEWAY="http://localhost:8080/ipfs/"
		export IPFS_PATH=$ENV_STORAGE_ROOT/ipfs-storage
		mkdir -p $IPFS_PATH
		;;
	*)
		unset IPFS_GATEWAY
		;;
esac

export TMPDIR=$ENV_LOTUS_TMP_DIR
mkdir -p $TMPDIR

export LOTUS_PATH=$ENV_LOTUS_ROOT
export FIL_PROOFS_PARAMETER_CACHE=$ENV_FIL_PARAM_CACHE

case $ENV_SECTOR_SIZE in
	32GiB|64GiB)
		export FIL_PROOFS_MAXIMIZE_CACHING=1
		export LOTUS_STORAGE_PATH=$ENV_LOTUS_STORAGE_ROOT-$ENV_SECTOR_SIZE
		;;
	*)
		export LOTUS_STORAGE_PATH=$ENV_LOTUS_STORAGE_ROOT
		export FIL_PROOFS_MAXIMIZE_CACHING=0
		;;
esac

export EXEC_LOTUS=$ENV_LOTUS_SRC_DIR/lotus
export EXEC_BENCH=$ENV_LOTUS_SRC_DIR/lotus-bench
export EXEC_LOTUS_STORAGE_MINER=$ENV_LOTUS_SRC_DIR/lotus-miner
export EXEC_LOTUS_SEAL_WORKER=$ENV_LOTUS_SRC_DIR/lotus-worker

if [ ! -d $ENV_LOTUS_SRC_DIR -o 		\
	 ! -f $EXEC_LOTUS -o 				\
	 ! -f $EXEC_LOTUS_STORAGE_MINER -o 	\
	 ! -f $EXEC_LOTUS_SEAL_WORKER ]; then
	echo "Lotus is not deployed, deploy now ~~"
	./lotus-deploy.sh
fi

export ENV_P1_WORKER_CNT=6

if [ "xtrue" == "x$ENV_HAS_GPU" ]; then
    unset BELLMAN_NO_GPU
	export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
	export FIL_PROOFS_USE_GPU_TREE_BUILDER=1
else
	export BELLMAN_NO_GPU=1
	export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=0
	export FIL_PROOFS_USE_GPU_TREE_BUILDER=0
fi
