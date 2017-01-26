# This script requires redis server to be running
# It takes its pid and get the Rss and AnonHugePages
# information and stores it in <#Rss> <#Anon> format.

result=smap.out
rm $result
pid=`pgrep redis-ser`
while true
do 
    a=$(cat /proc/$pid/smaps | grep Rss: | awk '{SUM += $2} END { print SUM}') 
    b=$(cat /proc/$pid/smaps | grep AnonHugePages: | awk '{SUM += $2} END { print SUM}')
    echo $a $b | tee -a $result
    sleep 1
done
