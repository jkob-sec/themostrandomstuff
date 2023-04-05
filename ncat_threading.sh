#!/bin/bash
thread=400

# Tested on flight htb machine

startPort=1
endPort=3269

ncCmd="nc -z -v -w 1 10.10.11.187"

ports=$(seq $startPort $endPort)

echo $ports | tr ' ' '\n' | xargs -I{} -P $thread sh -c "$ncCmd {} >/dev/null 2>&1 && echo {} is open"


#53 is open
#88 is open
#80 is open
#135 is open
#139 is open
#389 is open
#445 is open
#464 is open
#593 is open
#636 is open
#3269 is open
#3268 is open
#
#real	0m9.211s
#user	0m24.046s
#sys	0m5.806s


#time $(sudo nmap -sS -n -T4 -p 1-3269 --open 10.10.11.187)
#
#real	0m10.215s
#user	0m0.052s
#sys	0m0.031s
