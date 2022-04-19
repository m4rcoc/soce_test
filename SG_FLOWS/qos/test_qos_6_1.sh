#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p VERIFIER/Report/$config_type/${func}/
timeout 10 tcpdump -i $IF3 ether dst 00:13:01:00:00:01 -w VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF3_PORT_PCIe.pcap & 
