#!/bin/bash
# The purpose of this is to block common attacks coming from the node
iptables -A OUTPUT -p tcp --src 10.182.0.1/24 --tcp-flags ALL ALL -j DROP
iptables -A OUTPUT -p tcp --src 10.182.0.1/24 --tcp-flags ALL NONE -j DROP
iptables -A OUTPUT -p icmp --src 10.182.0.1/24 -m limit --limit 6/second --limit-burst 6 -j ACCEPT
iptables -A OUTPUT -p tcp --src 10.182.0.1/24  -m state --state NEW -m limit --limit 6/second --limit-burst 6 -j ACCEPT

iptables --append OUTPUT --protocol udp --src 10.182.0.1/24 --dport 514 --jump DROP

# If possible limit ALL outputs
# iptables -A OUTPUT -p tcp --tcp-flags ALL ALL -j DROP
# iptables -A OUTPUT -p tcp  --tcp-flags ALL NONE -j DROP
# iptables -A OUTPUT -p icmp -m limit --limit 6/second --limit-burst 6 -j ACCEPT
# iptables -A OUTPUT -p tcp -m state --state NEW -m limit --limit 6/second --limit-burst 6 -j ACCEPT

iptables --append OUTPUT --protocol udp --dport 514 --jump DROP
iptables --append OUTPUT --protocol tcp --dport 445 --jump DROP
iptables --append OUTPUT --protocol tcp --dport 135 --jump DROP
iptables --append OUTPUT --protocol tcp --match multiport --dports 137:139 --jump DROP
iptables --append OUTPUT --protocol udp --dport 135 --jump DROP
iptables --append OUTPUT --protocol udp --match multiport --dports 137:139 --jump DROP
iptables --append OUTPUT --protocol tcp --match multiport --dports 6660:6669 --jump DROP