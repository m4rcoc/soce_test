#!/bin/bash



source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"



# Insert traffic flows here:
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
timeout 10 tcpdump -i $IF1 -c 1500 ether dst 00:00:02:00:00:01 -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap & 
timeout 10 tcpdump -i $IF2 -c 1500 ether dst 00:00:02:00:00:01 -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap & 
timeout 10 tcpdump -i $IF3 -c 1500 ether dst 00:00:02:00:00:01 -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap & 
sleep 5

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" &
sudo python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"

#sudo python3 ${sw_dir}soce_generator.py --iface=$IF3 --filejson="SG_FLOWS/${func}/${test_function}_f4.json"