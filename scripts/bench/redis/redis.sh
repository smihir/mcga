#!/bin/sh

export PATH=$PWD/../../../src/bench/redis-3.0/src:$PATH

SERVER_PID=0
PINGPONGLOG="pingpong.log"
BENCHMARKLOG="benchmark.log"
BENCHMARKDISTLOG="benchmark-distribution.log"
SERVERLOG="redis.log"
PIPELINE=50
KEYSPACE=100
NUMREQ=100
RAM=`free | awk '/^Mem:/{print $2}'`
ROOT=1

if [ `id -u` -ne 0 ]; then
	echo "This script must be run as root for better results" 1>&2
	ROOT=0
fi

start_server() {
	if [ -z "$1" ];
	then 
		printf "No configuration specified...Exiting\n"
		exit
	fi

	printf "Staring Redis Server..."
	redis-server $1

	# Wait for redis to startup
	sleep 1

	# Check id redis has started
	if [ -f redis.pid ];
	then
		SERVER_PID=`cat redis.pid`
		printf "Done\n"
		printf "Redis pid: $PID\n"
	else
		printf "Failed\n"
		killall -9 redis-server
		exit
	fi
}

run_benchmark() {
	if [ "$#" -lt 4 ];
	then 
		printf "No Arguments specified...Exiting\n"
		pipeline=$1
		exit
	fi
	redis-benchmark -P $1 -t $2 -r $3 -n $4 > $BENCHMARKDISTLOG
}

kill_server() {
	if [ $SERVER_PID -ne 0 ];
	then
		printf "Killing Server with PID $SERVER_PID..."
		kill -term $SERVER_PID
		anywait $SERVER_PID
		printf "Done\n"
	fi
}

#http://stackoverflow.com/questions/1058047/wait-for-any-process-to-finish
anywait() {
	loops=0
	while kill -0 "$1" 2> /dev/null ; do
		if [ $loops -ge 60 ]; then
			printf "More than 1 minute the process still did not exit!! Kill it.\n"
			kill -9 $1
			loops=0
			continue
		fi
		sleep 1
		loops=$((loops+1))
	done
}

run_pingpong() {
	redis-cli --latency > $PINGPONGLOG
}

kill_pingpong() {
	CLIPID=`ps -e | grep redis-cli | awk '{print $1}'`
	kill -9 $CLIPID
	anywait $CLIPID
}

run_tests() {
	case "$1" in
		nosave)
			rm -rf *.rdb
			mkdir -p nosave
			start_server redis.nosave.conf
			run_benchmark $PIPELINE "set" $KEYSPACE $NUMREQ
			mv $BENCHMARKLOG nosave
			mv $BENCHMARKDISTLOG nosave
			run_benchmark $PIPELINE "get" $KEYSPACE $NUMREQ
			mv $BENCHMARKLOG nosave
			mv $BENCHMARKDISTLOG nosave
			kill_server
			mv $SERVERLOG nosave
			;;
		latencynosave)
			rm -rf *.rdb
			mkdir -p latencynosave
			start_server redis.nosave.conf
			run_pingpong &
			run_benchmark $PIPELINE "set" $KEYSPACE $NUMREQ
			mv $BENCHMARKLOG latencynosave
			mv $BENCHMARKDISTLOG latencynosave
			kill_pingpong
			mv $PINGPONGLOG latencynosave
			kill_server	
			mv $SERVERLOG latencynosave
			;;
		save)
			rm -rf *.rdb
			mkdir -p save
			start_server redis.nosave.conf
			run_benchmark $PIPELINE "set" $KEYSPACE $NUMREQ
			mv $BENCHMARKLOG save
			mv $BENCHMARKDISTLOG save
			run_benchmark $PIPELINE "get" $KEYSPACE $NUMREQ
			mv $BENCHMARKLOG save
			mv $BENCHMARKDISTLOG save
			kill_server
			mv $SERVERLOG save
			;;
		latencysave)
			rm -rf *.rdb
			mkdir -p latencysave
			start_server redis.nosave.conf
			run_pingpong &
			run_benchmark $PIPELINE "set" $KEYSPACE $NUMREQ
			mv $BENCHMARKLOG latencysave
			mv $BENCHMARKDISTLOG latencysave
			kill_pingpong
			mv $PINGPONGLOG latencysave
			kill_server	
			mv $SERVERLOG latencysave
			;;
	esac
}

clear_cache() {
	if [ $ROOT -ne 0 ]; then
		echo 3 > /proc/sys/vm/drop_caches
	fi
}

populate_test_params() {
	if [ $RAM -ge 16000000 ]; then
		PIPELINE=50
		KEYSPACE=200000000
		NUMREQ=120000000
	fi
}

printf "System Memory is $RAM KB\n"
populate_test_params
printf "Test Parameters: Pipelining $PIPELINE, Keyspace $KEYSPACE, NumReq $NUMREQ\n"
clear_cache
run_tests "nosave"
clear_cache
run_tests "latencynosave"
clear_cache
run_tests "save"
clear_cache
run_tests "latencysave"

mkdir -p results.$$
mv -f nosave latencynosave save latencysave results.$$
