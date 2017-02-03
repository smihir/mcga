# This script requires redis server to be running

pid=`pgrep redis-server | sort -n | head -1`
while true
do
    if [ ! -d /proc/$pid ];
    then
        break;
    fi
    ps -C "khugepaged" -L -o %cpu= >> khugepagedcpu.out
    sleep 0.01
done
