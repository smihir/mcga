#!/bin/bash

#UtilityWorkMessage ---------------------------------------------------------------------

trap onexit 1 2 3 15
function onexit() {
    local exit_status=${1:-$?}
    pkill -f hstore.tag
        exit $exit_status
}

# ---------------------------------------------------------------------

ENABLE_ANTICACHE=true

#SITE_HOST="dev3.db.pdl.cmu.local"
SITE_HOST="localhost"

#CLIENT_HOSTS=( "localhost")

CLIENT_HOSTS=( \
        "localhost" \
        "localhost" \
        "localhost" \
        "localhost" \
        )
N_HOSTS=4
BASE_CLIENT_THREADS=1
CLIENT_THREADS_PER_HOST=4
#BASE_SITE_MEMORY=8192
#BASE_SITE_MEMORY_PER_PARTITION=1024
BASE_SITE_MEMORY=2048
BASE_SITE_MEMORY_PER_PARTITION=1024
BASE_PROJECT="voter"
BASE_DIR=`pwd`
OUTPUT_DIR="data-new/voter/voter-"
#BLK_CON=1
BLK_EVICT=600
AC_THRESH=500
SCALE=100
BLOCK_SIZE_KB=256
DURATION_S=300
WARMUP_S=60
INTERVAL_S=2
PARTITIONS=8

for BLK_CON in 100 ; do
for BLOCK_SIZE in 256; do
for BLOCKING in 'false';  do
for BLOCK_MERGE in 'true'; do
    for DB in 'NVM' 'BERKELEY'; do
    #for DB in 'NVM' ; do
            OUTPUT_DIR=${OUTPUT_DIR}evict$((BLK_EVICT / 4))
            mkdir -p $OUTPUT_DIR

            for round in 1; do
                if [ "$BLOCKING" = "true" ]; then
                    block='sync'
                else
                    block='abrt'
                fi
                if [ "$BLOCK_MERGE" = "true" ]; then
                    block_merge='block'
                else
                    block_merge='tuple'
                fi
                if [ "$DB" = "NVM" ]; then
                    AC_DIR='/mnt/pmfs/aclevel1'
                else
                    AC_DIR="/data1/berk-level$round"
                fi
                echo "anticache_dir = ${AC_DIR}"
                BLOCK_SIZE_KB=$BLOCK_SIZE
                #BLK_EVICT=$((51200 / $BLOCK_SIZE_KB))
                OUTPUT_PREFIX="$OUTPUT_DIR/$round-voter-${DB}-${PARTITIONS}p-${BLK_CON}c-${N_HOSTS}h-${CLIENT_THREADS_PER_HOST}ct-sc$SCALE-${BLOCK_SIZE_KB}kb-${BLK_EVICT}b-${AC_THRESH}th-${DURATION_S}s-${block_merge}"
                LOG_PREFIX="logs/voter-nvm/$round-voter-${DB}-${PARTITIONS}p-${BLK_CON}c-${N_HOSTS}h-${CLIENT_THREADS_PER_HOST}ct-sc$SCALE-${BLOCK_SIZE_KB}kb-${BLK_EVICT}b-${AC_THRESH}th-${DURATION_S}s-${block_merge}"
                echo "log = $LOG_PREFIX"
                echo $OUTPUT_PREFIX

#ANTICACHE_BLOCK_SIZE=65536

#ANTICACHE_BLOCK_SIZE=262144
                ANTICACHE_BLOCK_SIZE=$(($BLOCK_SIZE_KB * 1024))
                ANTICACHE_THRESHOLD=.5
                DURATION=$((${DURATION_S} * 1000))
                WARMUP=$((${WARMUP_S} * 1000))
                INTERVAL=$((${INTERVAL_S} * 1000))

                BASE_ARGS=( \
# SITE DEBUG
                        "-Dsite.status_enable=false" \
                        "-Dsite.status_interval=10000" \
#    "-Dsite.status_exec_info=true" \
#    "-Dsite.status_check_for_zombies=true" \
#    "-Dsite.exec_profiling=true" \
#     "-Dsite.profiling=true" \
#    "-Dsite.txn_counters=true" \
#    "-Dsite.pool_profiling=true" \
#     "-Dsite.network_profiling=false" \
#     "-Dsite.log_backup=true"\
#    "-Dnoshutdown=true" \    

# Site Params
                        "-Dsite.jvm_asserts=false" \
                        "-Dsite.specexec_enable=false" \
                        "-Dsite.cpu_affinity_one_partition_per_core=true" \
#"-Dsite.cpu_partition_blacklist=0,2,4,6,8,10,12,14,16,18" \
#"-Dsite.cpu_utility_blacklist=0,2,4,6,8,10,12,14,16,18" \
#                        "-Dsite.network_incoming_limit_txns=500000" \
#                        "-Dsite.commandlog_enable=false" \
#                        "-Dsite.txn_incoming_delay=5" \
#                        "-Dsite.exec_postprocessing_threads=false" \
                        "-Dsite.anticache_eviction_distribution=even" \
                        "-Dsite.log_dir=$LOG_PREFIX" \
                        "-Dsite.specexec_enable=false" \

#    "-Dsite.queue_allow_decrease=true" \
#    "-Dsite.queue_allow_increase=true" \
#    "-Dsite.queue_threshold_factor=0.5" \

# Client Params
                        "-Dclient.scalefactor=${SCALE}" \
                        "-Dclient.memory=2048" \
                        "-Dclient.txnrate=8000" \
                        "-Dclient.warmup=${WARMUP}" \
                        "-Dclient.duration=${DURATION}" \
                        "-Dclient.interval=${INTERVAL}" \
                        "-Dclient.shared_connection=false" \
                        "-Dclient.blocking=true" \
                        "-Dclient.blocking_concurrent=${BLK_CON}" \ 
                        "-Dclient.throttle_backoff=100" \
                        "-Dclient.output_anticache_evictions=${OUTPUT_PREFIX}-evictions.csv" \
                        "-Dclient.output_anticache_profiling=${OUTPUT_PREFIX}-acprofiling.csv" \
#                       "-Dclient.output_anticache_access=${OUTPUT_PREFIX}-accesses.csv" \
                        "-Dclient.output_memory_stats=${OUTPUT_PREFIX}-memory.csv" \
                        "-Dclient.output_anticache_memory_stats=${OUTPUT_PREFIX}-anticache-memory.csv" \
#                        "-Dclient.weights=\"ReadRecord:50,UpdateRecord:50,*:0\"" \

# Anti-Caching Experiments
                        "-Dsite.anticache_enable=${ENABLE_ANTICACHE}" \
                        "-Dsite.anticache_enable_multilevel=false" \
                        "-Dsite.anticache_timestamps=${ENABLE_TIMESTAMPS}" \
#                        "-Dsite.anticache_batching=true" \
                        "-Dsite.anticache_profiling=true" \
                        "-Dsite.anticache_reset=false" \
                        "-Dsite.anticache_block_size=${ANTICACHE_BLOCK_SIZE}" \
                        "-Dsite.anticache_check_interval=10000" \
                        "-Dsite.anticache_threshold_mb=${AC_THRESH}" \
                        "-Dsite.anticache_blocks_per_eviction=${BLK_EVICT}" \
                        "-Dsite.anticache_max_evicted_blocks=1000000" \
                        "-Dsite.anticache_dbsize=1540M" \
                        "-Dsite.anticache_db_blocks=$BLOCKING" \
                        "-Dsite.anticache_block_merge=$BLOCK_MERGE" \
                        "-Dsite.anticache_dbtype=$DB" \
#    "-Dsite.anticache_evict_size=${ANTICACHE_EVICT_SIZE}" \
                        "-Dsite.anticache_dir=${AC_DIR}" \
                        #"-Dsite.anticache_dir=/mnt/pmfs/aclevel1" \
                        #"-Dsite.anticache_dir=/data1/berk-level$round" \
                        "-Dsite.anticache_levels=NVM,false,256K,4M;BERKELEY,false,256K,16G" \
                        #"-Dsite.anticache_multilevel_dirs=tmp/pmfs/nvm-level0;tmp/berk-level1" \
                        "-Dsite.anticache_multilevel_dirs=/mnt/pmfs/nvm-level0;/tmp/berk-level2" \
                        "-Dsite.anticache_threshold=${ANTICACHE_THRESHOLD}" \
                        "-Dclient.anticache_enable=false" \
                        "-Dclient.anticache_evict_interval=3000" \
                        "-Dclient.anticache_evict_size=${ANTICACHE_BLOCK_SIZE}" \
                        "-Dclient.output_csv=${OUTPUT_PREFIX}-results.csv" \

# CLIENT DEBUG
                        "-Dclient.output_txn_counters=${OUTPUT_PREFIX}-txncounters.csv" \
                        "-Dclient.output_clients=false" \
                        "-Dclient.profiling=false" \
                        "-Dclient.output_response_status=false" \
#                        "-Dclient.output_queue_profiling=${OUTPUT_PREFIX}-queue.csv" \
#                        "-Dclient.output_basepartitions=true" \
#"-Dclient.jvm_args=\"-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:-TraceClassUnloading\"" 
                        )

                EVICTABLE_TABLES=( \
                    "votes" \
                )
                EVICTABLES=""
                BATCHEVICTABLES=""
                if [ "$ENABLE_ANTICACHE" = "true" ]; then
                    for t in ${EVICTABLE_TABLES[@]}; do
                        EVICTABLES="${t},${EVICTABLES}"
                    done
                    for t in ${BATCHEVICTABLE_TABLES[@]}; do
                        BATCHEVICTABLES="${t},${BATCHEVICTABLES}"
                    done
                fi
 
# Compile
                HOSTS_TO_UPDATE=("$SITE_HOST")
                for CLIENT_HOST in ${CLIENT_HOSTS[@]}; do
                    NEED_UPDATE=1
                    for x in ${HOSTS_TO_UPDATE[@]}; do
                        if [ "$CLIENT_HOST" = "$x" ]; then
                            NEED_UPDATE=0
                            break
                        fi
                    done
                    if [ $NEED_UPDATE = 1 ]; then
                        HOSTS_TO_UPDATE+=("$CLIENT_HOST")
                    fi
                done
#for HOST in ${HOSTS_TO_UPDATE[@]}; do
#ssh $HOST "cd $BASE_DIR && git pull && ant compile" &
#done
                wait

                ant compile
#HSTORE_HOSTS="${SITE_HOST}:0:0-7"
                if [ "$PARTITIONS" = "1" ]; then
                    HSTORE_HOSTS="${SITE_HOST}:0:0"
                else
                    PART_NO=$((${PARTITIONS} - 1))
                    HSTORE_HOSTS="${SITE_HOST}:0:0-$PART_NO"
                fi
                echo "$HSTORE_HOSTS"

                NUM_CLIENTS=$((${PARTITIONS} * ${BASE_CLIENT_THREADS}))
                SITE_MEMORY=`expr $BASE_SITE_MEMORY + \( $PARTITIONS \* $BASE_SITE_MEMORY_PER_PARTITION \)`

# BUILD PROJECT JAR
                ant hstore-prepare \
                            -Dproject=${BASE_PROJECT} \
                            -Dhosts=${HSTORE_HOSTS} \
                            -Devictable=${EVICTABLES}
                test -f ${BASE_PROJECT}.jar || exit -1

# UPDATE CLIENTS
                CLIENT_COUNT=0
                CLIENT_HOSTS_STR=""
                for CLIENT_HOST in ${CLIENT_HOSTS[@]}; do
                    CLIENT_COUNT=`expr $CLIENT_COUNT + 1`
                    if [ ! -z "$CLIENT_HOSTS_STR" ]; then
                        CLIENT_HOSTS_STR="${CLIENT_HOSTS_STR}",
                    fi
                    CLIENT_HOSTS_STR="${CLIENT_HOSTS_STR}${CLIENT_HOST}"
                done

# DISTRIBUTE PROJECT JAR
                for HOST in ${HOSTS_TO_UPDATE[@]}; do
                    if [ "$HOST" != $(hostname) ]; then
                        scp -r ${BASE_PROJECT}.jar ${HOST}:${BASE_DIR} &
                    fi
                done
                wait

                echo "Client count $CLIENT_COUNT client hosts: $CLIENT_HOSTS_STR"
# EXECUTE BENCHMARK
                ant hstore-benchmark ${BASE_ARGS[@]} \
                                -Dproject=${BASE_PROJECT} \
                                -Dkillonzero=false \
                                -Dclient.threads_per_host=${NUM_CLIENTS} \
                                -Dsite.memory=${SITE_MEMORY} \
                                -Dclient.hosts=${CLIENT_HOSTS_STR} \
                                -Dclient.count=${CLIENT_COUNT}
                result=$?
                if [ $result != 0 ]; then
                    exit $result
                fi
        done
    done
done
done
done #BLOCK_SIZE
done #BLK_CON
