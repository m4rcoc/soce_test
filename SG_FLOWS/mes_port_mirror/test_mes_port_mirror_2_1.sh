#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_f1/
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_f2/

sudo timeout 70 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_f1/Recieved_$IF1.pcap &
sudo timeout 70 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_f1/Recieved_$IF2.pcap &
sudo timeout 70 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_f1/Recieved_$IF3.pcap &
sudo timeout 70 tcpdump -i $IF4  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_f1/Recieved_$IF4.pcap &

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1  --filejson="SG_FLOWS/${func}/${test_function}_f1.json" --start --config_type=$config_type --model=$model
sudo python3 ${sw_dir}soce_generator.py --iface=$IF1  --filejson="SG_FLOWS/${func}/${test_function}_f2.json" --start --config_type=$config_type --model=$model

