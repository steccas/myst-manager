#!/bin/bash
IPT="/sbin/iptables"
IPT6="/sbin/ip6tables"

IN_FACE="wg0"                   # NIC to reach
BR_FACE="br_myst_proxy_d"                    # br NIC 
S_IP="192.168.16.0/24"
D_IP="192.168.44.1"
D_PORT="4449"

## IPv4 ##
$IPT -t nat -I POSTROUTING 1 -s $S_IP -o $IN_FACE -j MASQUERADE
$IPT -I INPUT 1 -p tcp -s $S_IP --dst $D_IP --dport $D_PORT -j ACCEPT
$IPT -I FORWARD 1 -i $IN_FACE -o $BR_FACE -j ACCEPT
$IPT -I FORWARD 1 -i $BR_FACE -o $IN_FACE -j ACCEPT

## IPv6 (Uncomment) ##
## $IPT6 -t nat -I POSTROUTING 1 -s $S_IP_6 -o $IN_FACE -j MASQUERADE
## $IPT6 -I INPUT 1 -i $BR_FACE -j ACCEPT
## $IPT6 -I FORWARD 1 -i $IN_FACE -o $BR_FACE -j ACCEPT
## $IPT6 -I FORWARD 1 -i $BR_FACE -o $IN_FACE -j ACCEPT