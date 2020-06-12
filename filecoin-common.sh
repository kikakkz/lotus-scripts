#!/bin/bash

source ./mach-env.sh

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
export LOTUS_STORAGE_PATH=$ENV_LOTUS_STORAGE_ROOT
export WORKER_PATH=$ENV_LOTUS_WORKER_ROOT
export FIL_PROOFS_PARAMETER_CACHE=$ENV_FIL_PARAM_CACHE

case $ENV_SECTOR_SIZE in
	32GiB|64GiB)
		export FIL_PROOFS_MAXIMIZE_CACHING=1
		;;
	*)
		export FIL_PROOFS_MAXIMIZE_CACHING=0
		;;
esac

export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1

if [ ! -d $ENV_LOTUS_SRC_DIR ]; then
	echo "Lotus is not deployed, deploy now ~~"
	./lotus-deploy.sh
fi
