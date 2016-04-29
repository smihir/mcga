#!/bin/bash

export PATH=$PWD/../../src/ubench/fork/:$PATH

RAM=`free -m| awk '/^Mem:/{print $2}'`

if [ `id -u` -ne 0 ]; then
	echo "This script must be run as root"
	exit 1
fi

compile() {
    cd ../../src/ubench/fork/
	gcc fork_benchmark.c -o fork_benchmark
}

enable_thp() {
	sudo echo always > /sys/kernel/mm/transparent_hugepage/enabled
	echo "Transparent Huge Pages Enabled"
}

disable_thp() {
	sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled
	echo "Transparent Huge Pages Disabled"
}

run_benchmark() {
	rss=128
	RAMby3=$(($RAM / 3))
	while [ $rss -le $RAMby3 ]; do
		fork_benchmark $rss
		rss=$(($rss * 2))
	done
}

compile
enable_thp
run_benchmark
disable_thp
run_benchmark
enable_thp
