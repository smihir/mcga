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
	redis-benchmark -P $1 -t $2 -r $3 -n $4 | tee $BENCHMARKDISTLOG
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

anywait() {
	while kill -0 "$1" 2> /dev/null ; do
		sleep 0.5
	done
}

run_pingpong() {
	redis-cli --latency > $PINGPONGLOG
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
			PINGPONG_PID=$!
			run_benchmark $PIPELINE "set" $KEYSPACE $NUMREQ
			mv $BENCHMARKLOG latencynosave
			mv $BENCHMARKDISTLOG latencynosave
			kill -9 $PINGPONG_PID
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
			PINGPONG_PID=$!
			run_benchmark $PIPELINE "set" $KEYSPACE $NUMREQ
			mv $BENCHMARKLOG latencysave
			mv $BENCHMARKDISTLOG latencysave
			kill -9 $PINGPONG_PID
			mv $PINGPONGLOG latencysave
			kill_server	
			mv $SERVERLOG latencysave
			;;
	esac
}

run_tests "nosave"
run_tests "latencynosave"
run_tests "save"
run_tests "latencysave"

mkdir -p results.$$
mv -f nosave latencynosave save latencysave results.$$
