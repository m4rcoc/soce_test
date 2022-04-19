#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p VERIFIER/Report/$config_type/${func}/
timeout 60 tcpdump -i $IF2 -c 4500 ether src 00:aa:aa:aa:aa:aa -w VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap & 


sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"
sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"
sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f3.json"
