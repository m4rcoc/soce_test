#!/bin/bash



source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"



# Insert traffic flows here:



mkdir -p REPORTS/${func}
rm -r REPORTS/${func}/${test_function}.out

print_info "\tCapturing in remote MGT_PORT ($MGT_PORT) of the DUT [parallel process]" | tee -a REPORTS/${func}/${test_function}.out

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
echo $password | sudo -S timeout 10 tcpdump -i $MGT_PORT ether dst 01:80:c2:00:00:00 -w ${test_function}.pcap
" &

print_info "\tSending Reserved [01:80:c2:00:00:00] Multicast traffic through IF1" | tee -a REPORTS/${func}/${test_function}.out

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"

sleep 3
