#!/bin/bash

tokens=`ip token`
devs=""

for token in $tokens; do
	for tok in $token; do
		case $tok in
			token|::|dev) continue 		;;
			*)			  devs+="$tok "	;;
		esac
	done
done

##
## Only use 10G device
##
for dev in $devs; do
	rc=`dmesg | grep "$dev" | grep "ixgbe"`
	if [ "x" == "x$rc" ]; then continue; fi
	rc=`dmesg | grep "$dev" | grep "ready"`
	if [ "x" != "x$rc" ]; then candidates+="$dev "; fi
done

for cand in $candidates; do
	ENV_MACH_IP=`ip a show dev $cand | grep "inet " | awk -F "/" '{print $1}' | awk -F " " '{print $2}'`
	export ENV_MACH_IP
	break
done

if [ "x" != "x$ENV_MACH_IP" ]; then
	echo "Find 10Gbps ethernet $ENV_MACH_IP"
else
	echo "Fail to find valid 10Gbps ethernet" && exit 1
fi
