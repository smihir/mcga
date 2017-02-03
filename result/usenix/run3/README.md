# Results description
values not specified are defaults

## results-prctl12-1
scan_sleep_millisecs 0  

## results-prctl12-2
pages_to_scan 10223616 (39G, entire RAM of the system)  
scan_sleep_millisecs 1000

## results-prctl12-3
pages_to_scan 10223616 (39G, entire RAM of the system)  
scan_sleep_millisecs 10000

## results-prctl11-4
pages_to_scan 10223616 (39G, entire RAM of the system)  
scan_sleep_millisecs 10000

### Collecting extra logs (cpu, thp) from here onwards
## results-prctl12-5
pages_to_scan 10223616 (39G, entire RAM of the system)  
scan_sleep_millisecs 10000

## results-prctl11-6
pages_to_scan 10223616 (39G, entire RAM of the system)   
scan_sleep_millisecs 10000

### More logs! (khugepaged cpu usage)
## results-prctl11-7
pages_to_scan 10223616 (39G, entire RAM of the system)   
scan_sleep_millisecs 10000

## results-prctl12-8
pages_to_scan 10223616 (39G, entire RAM of the system)   
scan_sleep_millisecs 10000

### More logs! (khugepaged ps cpu usage per 10ms)
## results-prctl12-9
pages_to_scan 10223616 (39G, entire RAM of the system)  
scan_sleep_millisecs 10000

## results-prctl12-10
pages_to_scan 10223616 (39G, entire RAM of the system)  
scan_sleep_millisecs 10000

### cgroups to throttle khugepaged
## results-prctl12-11
pages_to_scan 10223616 (39G, entire RAM of the system)  
scan_sleep_millisecs 10000  
cgroup cpu period 10s  
cgroup cpu quota 0.5s (5% cpu usage)

## results-prctl12-12
pages_to_scan 10223616 (39G, entire RAM of the system)  
scan_sleep_millisecs 10000  
cgroup cpu period 1s  
cgroup cpu quota 0.05s (5% cpu usage)
