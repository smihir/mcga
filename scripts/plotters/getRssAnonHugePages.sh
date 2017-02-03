# This script requires redis server to be running
# It takes its pid and get the Rss and AnonHugePages
# information and stores it in <#Rss> <#Anon> format.

smap=smap.out
khugepagedcpu=khugepagedcpu.out
thpvmstat=thpvmstat.out

rm -rf $smap
rm -rf $khugepagedcpu
rm -rf $thpvmstat

pid=`pgrep redis-server | sort -n | head -1`
pid_khugepaged=`pgrep hugepaged`
while true
do
    if [ ! -d /proc/$pid ];
    then
        grep thp_promote thpvmstat.out | awk '{print $2}' > thppromote.out
        grep "thp_collapse_alloc " thpvmstat.out | awk '{print $2}' > thp_collapse_alloc.out

        cat cpustat.out | awk '{print $15}' | awk '
                NR == 1{old = $1; next}     # if 1st line
                {print $1 - old; old = $1}  # else...
                ' > cpuPerSec.out

        break;
    fi
    a=$(cat /proc/$pid/smaps | grep Rss: | awk '{SUM += $2} END { print SUM}')
    b=$(cat /proc/$pid/smaps | grep AnonHugePages: | awk '{SUM += $2} END { print SUM}')
    cat /proc/vmstat | grep thp >> thpvmstat.out
    cat /proc/$pid_khugepaged/stat >> cpustat.out

    echo $a $b | tee -a $smap
    sleep 1
done
