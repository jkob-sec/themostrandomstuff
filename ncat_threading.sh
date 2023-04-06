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

# sudo nmap -n -sS -T5 -p 1-3269 --max-retries=0 --max-rtt-timeout=5 --initial-rtt-timeout=5 10.10.11.187
# Starting Nmap 7.80 ( https://nmap.org ) at 2023-04-06 18:50 UTC
# Warning: 10.10.11.187 giving up on port because retransmission cap hit (0).
# Nmap scan report for 10.10.11.187
# Host is up (0.047s latency).
# Not shown: 3257 filtered ports
# PORT     STATE SERVICE
# 53/tcp   open  domain
# 80/tcp   open  http
# 88/tcp   open  kerberos-sec
# 135/tcp  open  msrpc
# 139/tcp  open  netbios-ssn
# 389/tcp  open  ldap
# 445/tcp  open  microsoft-ds
# 464/tcp  open  kpasswd5
# 593/tcp  open  http-rpc-epmap
# 636/tcp  open  ldapssl
# 3268/tcp open  globalcatLDAP
# 3269/tcp open  globalcatLDAPssl
# 
# Nmap done: 1 IP address (1 host up) scanned in 4.28 seconds
