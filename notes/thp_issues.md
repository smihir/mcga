# THP issues
Several people have established that enabling THP on servers can cause problems
like growing Resident Set Size(RSS) of their applications unreasonably or result
in a drop in I/O rates. The following list is compiled from the experience of
various vendors and individuals. Some of the links contain some simple code
snippets to reproduce the issues, we are using some of them to reproduce the
problems for our study.

## Issues reported online
- Blogs published by [Oracle](https://blogs.oracle.com/linux/entry/performance_issues_with_transparent_huge) recommends disabling THP
- Redis issues with THP have been widely reported online, but [this blog](http://antirez.com/news/84) gives steps to reproduce.
- Issue reported in the [VoltDB blog](https://voltdb.com/blog/linux-transparent-huge-pages-and-voltdb)

## Scripts for examining Issues
Redhat has a [page](http://developerblog.redhat.com/2014/03/10/examining-huge-pages-or-transparent-huge-pages-performance/) which give some sample systemtap scripts to evaluate THP performance.
