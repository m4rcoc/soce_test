#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p VERIFIER/Report/$config_type/${func}/$test_function

mkdir -p REPORTS/${func}

rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1


print_info "\tSending Multicast traffic through IF1 [parallel process]" | tee -a REPORTS/${func}/${test_function}.out

python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" &

sleep 5

print_info "\tSending IGMPv2 report through IF2" | tee -a REPORTS/${func}/${test_function}.out

python3 SW/igmp/igmp_generator.py -v 2 -t report -r 0.1 -i $IF2 | tee -a REPORTS/${func}/${test_function}.out

fast_soce_cli "
statistics reset_all_statistics SWITCH
" -r

print_info "\tWaiting 1 second for SWITCH forwarding verification" | tee -a REPORTS/${func}/${test_function}.out
sleep 1
fast_soce_cli "
igmp snooping_status
statistics get_tx_basic_statistics ${port_1_config}
statistics get_tx_basic_statistics ${port_2_config}
" -r


print_info "\tSending IGMPv2 leave through IF2" | tee -a REPORTS/${func}/${test_function}.out

python3 SW/igmp/igmp_generator.py -v 2 -t leave -r 0.1 -i $IF2 | tee -a REPORTS/${func}/${test_function}.out

timeout 5 tcpdump -i $IF2 ether src 00:AA:AA:AA:AA:AA -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
timeout 5 tcpdump -i $IF3 ether src 00:AA:AA:AA:AA:AA -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &

fast_soce_cli "
statistics reset_all_statistics SWITCH
" -r

print_info "\tWaiting 1 second for SWITCH forwarding verification" | tee -a REPORTS/${func}/${test_function}.out
sleep 1

fast_soce_cli "
igmp snooping_status
statistics get_tx_basic_statistics ${port_1_config}
statistics get_tx_basic_statistics ${port_2_config}
" -r

sleep 8
