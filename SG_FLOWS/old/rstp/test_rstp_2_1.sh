#!/bin/bash
#no modificar!!!!
test_function=$1
func=$2
config_type=$3

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
sudo timeout 120 tcpdump -i $IF1 -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 120 tcpdump -i $IF2 -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 120 tcpdump -i $IF3 -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" --start
sudo python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f2.json" --start
sudo python3 ${sw_dir}soce_generator.py --iface=$IF3 --filejson="SG_FLOWS/${func}/${test_function}_f3.json" --start