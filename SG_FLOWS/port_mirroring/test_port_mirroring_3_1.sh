#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:
sudo timeout 100 tcpdump -i $IF3 -c 200000 ether src AA:AA:AA:AA:AA:AA or ether src DD:DD:DD:DD:DD:DD -w VERIFIER/Report/$config_type/port_mirroring/$test_function/Received_$IF3.pcap &

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1  --filejson="SG_FLOWS/${func}/${test_function}_f1.json" --start --config_type=$config_type&
sudo python3 ${sw_dir}soce_generator.py --iface=$IF2  --filejson="SG_FLOWS/${func}/${test_function}_f2.json" --start --config_type=$config_type&
sudo python3 ${sw_dir}soce_generator.py --iface=$IF4  --filejson="SG_FLOWS/${func}/${test_function}_f3.json" --start --config_type=$config_type

