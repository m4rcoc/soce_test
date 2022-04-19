#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

cap_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
cap_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap

mkdir -p "${cap_IF2%/*}" && touch $cap_IF2
mkdir -p "${cap_IF1%/*}" && touch $cap_IF1



# sudo timeout 20 tcpdump -i $IF2 -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
# sudo timeout 20 tcpdump -i $IF1 -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" &
sudo python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f2.json" &
sudo python3 ${sw_dir}soce_generator.py --iface=$IF3 --filejson="SG_FLOWS/${func}/${test_function}_f3.json" &
sudo python3 ${sw_dir}soce_generator.py --iface=$IF4 --filejson="SG_FLOWS/${func}/${test_function}_f4.json"

print_info "HEREEEEE"


