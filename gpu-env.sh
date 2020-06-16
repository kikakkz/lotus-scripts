#!/bin/bash

GPU_DESC=`lspci | grep NV`
if [ "x" == "x$GPU_DESC" ]; then
	export ENV_HAS_GPU=false
else
	export ENV_HAS_GPU=true
fi
