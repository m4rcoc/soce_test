#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}

cap_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
cap_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap
cap_IF4=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap

mkdir -p "${cap_IF2%/*}" && touch $cap_IF2
mkdir -p "${cap_IF3%/*}" && touch $cap_IF3
mkdir -p "${cap_IF4%/*}" && touch $cap_IF4

print_info "\tCapturing traffic through IF2. IF3 and IF4 interfaces (filter ether src 00:aa:aa:aa:aa:aa) [parallel process]"
sudo timeout 10 tcpdump -i $IF2 ether src 00:AA:AA:AA:AA:AA -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 10 tcpdump -i $IF3 ether src 00:AA:AA:AA:AA:AA -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sudo timeout 10 tcpdump -i $IF4 ether src 00:AA:AA:AA:AA:AA -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &


print_info "\tSending unicast traffic through IF1 (00:aa:aa:aa:aa:aa -> 00:bb:bb:bb:bb:bb)"
sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"
