#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

cap_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
cap_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap

mkdir -p "${cap_IF1%/*}" && touch $cap_IF1
mkdir -p "${cap_IF2%/*}" && touch $cap_IF2

timeout 10 tcpdump -i $IF1 -c 961 -w $cap_IF1 &
timeout 10 tcpdump -i $IF2 -c 961 -w $cap_IF2 &

ifconfig $IF1 mtu 9100
ifconfig $IF2 mtu 9100
ifconfig $IF3 mtu 9100
# ifconfig $IF4 mtu 9010
sleep 5

fast_soce_cli "
statistics reset_all_statistics SWITCH
"
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"

rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1
fast_soce_cli "
statistics get_rx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_1_config
statistics get_rx_advanced_statistics $port_0_config
statistics get_tx_advanced_statistics $port_1_config
" -r

sleep 2

ifconfig $IF1 mtu 1500
ifconfig $IF2 mtu 1500
ifconfig $IF3 mtu 1500
# ifconfig $IF4 mtu 1500
