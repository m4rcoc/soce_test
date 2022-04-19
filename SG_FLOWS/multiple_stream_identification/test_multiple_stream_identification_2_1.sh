#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}

cap_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap

mkdir -p "${cap_IF2%/*}" && touch $cap_IF2

timeout 25 tcpdump -i $IF2 ether src 00:AA:AA:AA:AA:AA -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &

python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f3.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f4.json"
sleep 1

rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1
print_info "\tReading Stream Identification statistics:" | tee -a REPORTS/${func}/${test_function}.out
fast_soce_cli "
stream_identification get_per_port_per_stream_statistics $port_0_config 0
stream_identification get_per_port_per_stream_statistics $port_0_config 1
stream_identification get_per_port_per_stream_statistics $port_0_config 2
stream_identification get_per_port_per_stream_statistics $port_0_config 3
stream_identification get_per_port_statistics $port_0_config
" | tee -a REPORTS/${func}/${test_function}.out

