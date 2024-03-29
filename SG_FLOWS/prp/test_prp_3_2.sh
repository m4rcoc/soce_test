#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

cap_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
cap_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

mkdir -p "${cap_IF1%/*}" && touch $cap_IF1
mkdir -p "${cap_IF3%/*}" && touch $cap_IF3

timeout 10 tcpdump -i $IF1 ether src 00:AA:AA:AA:AA:AA -c 1500 -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
timeout 10 tcpdump -i $IF3 ether src 00:AA:AA:AA:AA:AA -c 1500 -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &

python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"


