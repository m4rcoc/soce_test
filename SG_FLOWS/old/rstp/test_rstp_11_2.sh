#!/bin/bash
#no modificar!!!!
test_function=$1
func=$2
config_type=$3

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/

sudo timeout 30 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 30 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 30 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sleep 5
sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/RSTP_app/RSTP_frame_format/MakeRootPortBadProtocolIdConfig   $IF2
python3 SW/RSTP_MSTP/RSTP_app/rstp.py -t  SW/RSTP_MSTP/RSTP_app/RSTP_frame_format/MakeRootPortBadProtocolIdConfig  &

