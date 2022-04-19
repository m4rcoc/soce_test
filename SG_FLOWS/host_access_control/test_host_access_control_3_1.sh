#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}

mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/

print_info "\tCapturing traffic through IF2. IF3 and IF4 interfaces (filter ether src 00:aa:aa:aa:aa:aa) [parallel process]"
sudo timeout 30 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 30 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 30 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sudo timeout 30 tcpdump -i $IF4  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &


print_info "\tSending unicast traffic through IF1 (00:aa:aa:aa:aa:aa -> 00:bb:bb:bb:bb:bb)"
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "echo $password | sudo -S timeout 30 tcpdump -i $MGT_PORT -w ${test_function}_$MGT_PORT.pcap" &

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"

sleep 30
sshpass -p $password sftp $username@$ip:/home/$username/${test_function}_$MGT_PORT.pcap VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_$MGT_PORT.pcap