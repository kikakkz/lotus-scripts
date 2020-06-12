#!/bin/bash

echo "Deploy lotus revision $ENV_LOTUS_REV to $ENV_LOTUS_SRC_DIR"
git clone https://github.com/filecoin-project/lotus.git $ENV_LOTUS_SRC_DIR

export RUSTUP_DIST_SERVER="https://mirrors.tuna.tsinghua.edu.cn/rustup"
export RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"
export GOPROXY=https://goproxy.cn,direct
export FFI_BUILD_FROM_SOURCE=1
export RUSTFLAGS="-C target-cpu=native -O"

cd $ENV_LOTUS_SRC_DIR
git checkout $ENV_LOTUS_REV
if [ 0 != $? ]; echo "Fail to checkout revision $ENV_LOTUS_REV"; exit 1; fi
make clean all
