#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}

cap_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
cap_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
cap_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap
cap_NET=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_NET.pcap

mkdir -p "${cap_IF1%/*}" && touch $cap_IF1
mkdir -p "${cap_IF2%/*}" && touch $cap_IF2
mkdir -p "${cap_IF3%/*}" && touch $cap_IF3
mkdir -p "${cap_NET%/*}" && touch $cap_NET

timeout 50 tcpdump -i $IF1 igmp and ip src 192.168.5.64 -w $cap_IF1 &
timeout 50 tcpdump -i $IF2 igmp and ip src 192.168.6.64 -w $cap_IF2 &
timeout 50 tcpdump -i $IF3 igmp and ip src 192.168.7.64 -w $cap_IF3 &
timeout 50 tcpdump -i $iface_host igmp and ip src 0.0.0.0 -w $cap_NET &
