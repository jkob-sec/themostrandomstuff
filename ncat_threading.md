## Quick comparison of each host scan
ncat threading \
eal	0m9.213s \
user	0m20.762s \
sys	0m4.873s

```bash
#!/bin/bash
thread=400

# Tested on flight htb machine

startPort=1
endPort=3269

ncCmd="nc -z -v -w 1 10.10.11.187"

ports=$(seq $startPort $endPort)

echo $ports | tr ' ' '\n' | xargs -I{} -P $thread sh -c "$ncCmd {} >/dev/null 2>&1 && echo {} is open"
```

rustscan
```console
time ./rustscan -a 10.10.11.187 --range 1-3269 -n -b 3269 --ulimit 150000
.----. .-. .-. .----..---.  .----. .---.   .--.  .-. .-.
| {}  }| { } |{ {__ {_   _}{ {__  /  ___} / {} \ |  `| |
| .-. \| {_} |.-._} } | |  .-._} }\     }/  /\  \| |\  |
`-' `-'`-----'`----'  `-'  `----'  `---' `-'  `-'`-' `-'
The Modern Day Port Scanner.
________________________________________
: http://discord.skerritt.blog           :
: https://github.com/RustScan/RustScan :
 --------------------------------------
0day was here ♥

[~] The config file is expected to be at "/home/rtz/.rustscan.toml"
[~] Automatically increasing ulimit value to 150000.
Open 10.10.11.187:53
Open 10.10.11.187:80
Open 10.10.11.187:88
Open 10.10.11.187:135
Open 10.10.11.187:139
Open 10.10.11.187:389
Open 10.10.11.187:593
Open 10.10.11.187:636
Open 10.10.11.187:3268
[~] Starting Script(s)
[~] Starting Nmap 7.80 ( https://nmap.org ) at 2023-04-06 19:37 UTC
Initiating Ping Scan at 19:37
Scanning 10.10.11.187 [2 ports]
Completed Ping Scan at 19:37, 0.04s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 19:37
Completed Parallel DNS resolution of 1 host. at 19:37, 0.01s elapsed
DNS resolution of 1 IPs took 0.01s. Mode: Async [#: 2, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 19:37
Scanning 10.10.11.187 [9 ports]
Discovered open port 139/tcp on 10.10.11.187
Discovered open port 135/tcp on 10.10.11.187
Discovered open port 80/tcp on 10.10.11.187
Discovered open port 53/tcp on 10.10.11.187
Discovered open port 88/tcp on 10.10.11.187
Discovered open port 636/tcp on 10.10.11.187
Discovered open port 389/tcp on 10.10.11.187
Discovered open port 3268/tcp on 10.10.11.187
Discovered open port 593/tcp on 10.10.11.187
Completed Connect Scan at 19:37, 0.04s elapsed (9 total ports)
Nmap scan report for 10.10.11.187
Host is up, received syn-ack (0.045s latency).
Scanned at 2023-04-06 19:37:05 UTC for 0s

PORT     STATE SERVICE        REASON
53/tcp   open  domain         syn-ack
80/tcp   open  http           syn-ack
88/tcp   open  kerberos-sec   syn-ack
135/tcp  open  msrpc          syn-ack
139/tcp  open  netbios-ssn    syn-ack
389/tcp  open  ldap           syn-ack
593/tcp  open  http-rpc-epmap syn-ack
636/tcp  open  ldapssl        syn-ack
3268/tcp open  globalcatLDAP  syn-ack

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 0.12 seconds


real	0m1.750s
user	0m0.041s
sys	0m0.058s
```

nmap 5 threads
```console
sudo nmap -n -sS -T5 -p 1-3269 --max-retries=0 --max-rtt-timeout=5 --initial-rtt-timeout=5 10.10.11.187
Starting Nmap 7.80 ( https://nmap.org ) at 2023-04-06 18:50 UTC
Warning: 10.10.11.187 giving up on port because retransmission cap hit (0).
Nmap scan report for 10.10.11.187
Host is up (0.047s latency).
Not shown: 3257 filtered ports
PORT     STATE SERVICE
53/tcp   open  domain
80/tcp   open  http
88/tcp   open  kerberos-sec
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
389/tcp  open  ldap
445/tcp  open  microsoft-ds
464/tcp  open  kpasswd5
593/tcp  open  http-rpc-epmap
636/tcp  open  ldapssl
3268/tcp open  globalcatLDAP
3269/tcp open  globalcatLDAPssl

Nmap done: 1 IP address (1 host up) scanned in 4.28 seconds
```

sudo nmap -n -sS -T5 -p53,80,88,135,139,389,445,464,593,636,3268,3269 --max-retries=0 --max-rtt-timeout=5 --initial-rtt-timeout=5 10.10.11.187
```
sudo nmap -n -sS -T5 -p53,80,88,135,139,389,445,464,593,636,3268,3269 --max-retries=0 --max-rtt-timeout=5 --initial-rtt-timeout=5 10.10.11.187
[sudo] password for rtz: 
Starting Nmap 7.80 ( https://nmap.org ) at 2023-04-06 19:46 UTC
Nmap scan report for 10.10.11.187
Host is up (0.047s latency).

PORT     STATE SERVICE
53/tcp   open  domain
80/tcp   open  http
88/tcp   open  kerberos-sec
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
389/tcp  open  ldap
445/tcp  open  microsoft-ds
464/tcp  open  kpasswd5
593/tcp  open  http-rpc-epmap
636/tcp  open  ldapssl
3268/tcp open  globalcatLDAP
3269/tcp open  globalcatLDAPssl

Nmap done: 1 IP address (1 host up) scanned in 0.29 seconds
```
