#!/bin/bash
folder=$1
if [ -z "$folder" ]; then
    echo "please specify folder"
    exit 1
fi
redisstat=$folder/redisstat.out
redisperf=$folder/redis-perf
clk_tick=`getconf CLK_TCK`
utime_start=`head -n1 $redisstat | awk '{print \$14}'`
utime_end=`tail -n1 $redisstat | awk '{print \$14}'`
stime_start=`head -n1 $redisstat | awk '{print \$15}'`
stime_end=`tail -n1 $redisstat | awk '{print \$15}'`
Total_utime=$(( ($utime_end - $utime_start) / $clk_tick ))
Total_stime=$(( ($stime_end - $stime_start) / $clk_tick ))

dTLB_load=`grep dTLB-load-misses $redisperf | awk '{print \$1}' | sed "s/,//g"`
dTLB_store=`grep dTLB-store-misses $redisperf | awk '{print \$1}' | sed "s/,//g"`
Total_dTLB=$(( $dTLB_load + $dTLB_store ))

echo "the dTLB miss counts are $dTLB_load and $dTLB_store total $Total_dTLB"
echo "the utimes are $utime_start and $utime_end diff $Total_utime"
echo "the stimes are $stime_start and $stime_end diff $Total_stime"
