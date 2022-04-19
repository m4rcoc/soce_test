#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

cap_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

mkdir -p "${cap_IF3%/*}" && touch $cap_IF3

timeout 5 tcpdump -i $IF3 ether host f4:f2:6d:3e:ad:bc -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &


tcpreplay -i $IF1 SG_FLOWS/${func}/hsr_wrong_lsdu.pcap
tcpreplay -i $IF2 SG_FLOWS/${func}/hsr_wrong_lsdu.pcap
