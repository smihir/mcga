# superpages
Most architectures provide support for large memory pages, called superpages.
They lower the pressure on TLB by enabling a single entry to map a large
physical address region to virtual memory. Linux has added support for using
superpages via *libhugetlbfs* and more recently *Transparent Huge Pages (THP)*.

The idea of THP is great because it allows the system to use superpages without
the application developer needing to use special APIs or reserving memory at
boot time à la *libhugetlbfs*. But over time several crippling issues have been
discovered with THP and many vendors recommend to completely disable THP or
enable only for programs that explicitly want to use it.

The goal of this work is to identify the issues, formally measure the performance
degradation caused by the THP implementation and while doing so learn more about
how the current implementation is leading to the problematic events when dealing
with huge pages. The next stage will deal with designing solutions to address
the issues depending on the outcome of our measurement studies.

## Repository structure
```
|-- LICENSE
|-- README.md : This README
|-- notes : my thoughts and links to online and other literature for reference
`-- src
    `-- mon : source code for scripts to monitor health and state of a system
              while THP implementation is being exercised
```
