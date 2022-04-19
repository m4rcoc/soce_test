#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

cap_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
cap_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
cap_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

mkdir -p "${cap_IF1%/*}" && touch $cap_IF1
mkdir -p "${cap_IF2%/*}" && touch $cap_IF2
mkdir -p "${cap_IF3%/*}" && touch $cap_IF3

timeout 15 tcpdump -i $IF1 -w $cap_IF1 &
timeout 15 tcpdump -i $IF2 -w $cap_IF2 &
timeout 15 tcpdump -i $IF3 -w $cap_IF3 &

tcpreplay -i $IF2 SG_FLOWS/${func}/prp_ptp_default_l2_master.pcap
