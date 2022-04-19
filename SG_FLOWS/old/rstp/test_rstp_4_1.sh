#!/bin/bash
#no modificar!!!!
test_function=$1
func=$2
config_type=$3

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/

sudo timeout 10 tcpdump -i $IF1 'stp' -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 10 tcpdump -i $IF2 'stp' -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 10 tcpdump -i $IF3 'stp' -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &