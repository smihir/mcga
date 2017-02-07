#!/bin/bash
folder=$1
if [ -z "$folder" ]; then
    echo "please specify folder"
    exit 1
fi
frequency="2401000"
redisstat=$folder/redisstat.out
redisperf=$folder/redis-perf
clk_tick=`getconf CLK_TCK`
khugepaged_stats=$folder/cpuPerSec.out
benchmark_stats=$folder/benchmark-stats.log
khugepaged_perf=$folder/khugepaged-perf

utime_start=`head -n1 $redisstat | awk '{print \$14}'`
utime_end=`tail -n1 $redisstat | awk '{print \$14}'`
stime_start=`head -n1 $redisstat | awk '{print \$15}'`
stime_end=`tail -n1 $redisstat | awk '{print \$15}'`
Total_utime=$(( ($utime_end - $utime_start) * 1000 / $clk_tick  ))
Total_stime=$(( ($stime_end - $stime_start) * 1000 / $clk_tick ))

dTLB_load=`grep dTLB-load-misses $redisperf | awk '{print \$1}' | sed "s/,//g"`
dTLB_store=`grep dTLB-store-misses $redisperf | awk '{print \$1}' | sed "s/,//g"`
dTLB_cycles=`grep r408 $redisperf | awk '{print \$1}' | sed "s/,//g"`
cycles=`grep cycles $redisperf | awk '{print \$1}' | sed "s/,//g"`
perf_time=`grep "seconds time elapsed" $redisperf | awk '{print \$1}' | sed "s/,//g"`
redis_throughput=`grep "requests per second" $benchmark_stats | awk '{print \$1}' | sed "s/,//g"`


Total_dTLB=$(( $dTLB_load + $dTLB_store ))
cycles_per_fault=$(( $dTLB_cycles / $dTLB_load ))
cycles_except_TLB=$(( $cycles - $dTLB_cycles ))

dTLB_time=$(( $dTLB_cycles / $frequency ))
time_per_fault=$(( $cycles_per_fault / $frequency ))
time_except_TLB=$(( $cycles_except_TLB / $frequency ))
utime_except_TLB=$(( $Total_utime - $dTLB_time ))

khugepaged_stime=`tail -n1 $khugepaged_stats | awk '{print \$1}'`
a=$(cat $khugepaged_stats | awk '{if ($1 > 0) SUM += $1} END { print SUM}')
khugepaged_cycles=`grep cycles $khugepaged_perf | awk '{print \$1}' | sed "s/,//g"`


echo "the utimes is $Total_utime, stime is $Total_stime total cycles $cycles perf time $perf_time"
echo "the dTLB miss counts are $dTLB_load and $dTLB_store total $Total_dTLB"
echo "time spent in page walks due to TLB requests $dTLB_time cycles $dTLB_cycles"
echo "cycles per TLB request $cycles_per_fault"
echo "time except TLB faults $time_except_TLB utime except dTLB faults $utime_except_TLB"
echo "khugepaged cycles = $khugepaged_cycles time $a and $khugepaged_stime"
echo "THROUGHPUT $redis_throughput"
