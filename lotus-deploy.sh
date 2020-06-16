#!/bin/bash

echo "Deploy lotus revision $ENV_LOTUS_REV to $ENV_LOTUS_SRC_DIR"

source ./prepare-compiler

if [ ! -d $ENV_LOTUS_SRC_DIR ]; then
	git clone https://github.com/filecoin-project/lotus.git $ENV_LOTUS_SRC_DIR
	if [ 0 != $? ]; then echo "Fail to clone lotus"; exit 1; fi
	cd $ENV_LOTUS_SRC_DIR
	git checkout $ENV_LOTUS_REV
	if [ 0 != $? ]; then echo "Fail to checkout revision $ENV_LOTUS_REV"; exit 1; fi
	git submodule update --init --recursive
	if [ 0 != $? ]; then echo "Fail to checkout submodule revision $ENV_LOTUS_REV"; exit 1; fi
fi


cd $ENV_LOTUS_SRC_DIR
REPLACE_FILE=$ENV_LOTUS_SRC_DIR/cmd/lotus-seal-worker/main.go
PATCH_FILE=$REPLACE_FILE.patch
lineno=`sed -n '/taskTypes = append(taskTypes, sealtasks.TTCommit2)/'= $REPLACE_FILE`
if [ "x" != "x$lineno" -a ! -f $PATCH_FILE ]; then
	sed -i "${lineno}i taskTypes = append(taskTypes, sealtasks.TTCommit1)" $REPLACE_FILE
	touch $PATCH_FILE
fi

REPLACE_FILE=$ENV_LOTUS_SRC_DIR/extern/filecoin-ffi/rust/rust-toolchain
echo "nightly-2020-05-04" > $REPLACE_FILE

export GOPROXY=https://goproxy.cn,direct
export FFI_BUILD_FROM_SOURCE=1
export RUSTFLAGS="-C target-cpu=native -O"

cd $ENV_LOTUS_SRC_DIR
make clean all
if [ 0 != $? ]; then echo "Fail to compile revision $ENV_LOTUS_REV"; exit 1; fi
