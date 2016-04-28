#!/bin/bash
gcc fork_benchmark.c -o fork_benchmark
sudo echo always > /sys/kernel/mm/transparent_hugepage/enabled
./fork_benchmark 128
./fork_benchmark 256
./fork_benchmark 512
./fork_benchmark 1024
./fork_benchmark 2048
./fork_benchmark 4096
./fork_benchmark 8192
#./fork_benchmark 16384
#./fork_benchmark 32768
#./fork_benchmark 65536

sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled
./fork_benchmark 128
./fork_benchmark 256
./fork_benchmark 512
./fork_benchmark 1024
./fork_benchmark 2048
./fork_benchmark 4096
./fork_benchmark 8192


sudo echo always > /sys/kernel/mm/transparent_hugepage/enabled
