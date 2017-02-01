# This script requires redis server to be running
# It takes its pid and get the Rss and AnonHugePages
# information and stores it in <#Rss> <#Anon> format.

result=smap.out
rm -rf $result
rm -rf khugepagedcpu.out
rm -rf thpvmstat.out
pid=`pgrep redis-server`
while true
do
    if [ ! -d /proc/$pid ];
    then
        grep thp_promote thpvmstat.out | awk '{print $2}' > thppromote.out
        grep "thp_collapse_alloc " thpvmstat.out | awk '{print $2}' > thp_collapse_alloc.out
        break;
    fi
    a=$(cat /proc/$pid/smaps | grep Rss: | awk '{SUM += $2} END { print SUM}') 
    b=$(cat /proc/$pid/smaps | grep AnonHugePages: | awk '{SUM += $2} END { print SUM}')
    ps -C "khugepaged" -L -o %cpu=,psr= >> khugepagedcpu.out
    cat /proc/vmstat | grep thp >> thpvmstat.out
    echo $a $b | tee -a $result    
    sleep 1
done
