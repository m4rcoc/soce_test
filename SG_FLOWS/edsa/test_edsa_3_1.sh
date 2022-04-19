#!/bin/bash



source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"



# Insert traffic flows here:



mkdir -p REPORTS/${func}
rm -r REPORTS/${func}/${test_function}.out

print_info "\tCapturing in remote virtual ports ($port_0_name, $port_1_name, $port_2_name and $port_3_name) of the DUT [parallel process]" | tee -a REPORTS/${func}/${test_function}.out

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
mkdir -p ${test_function}
printf '\n'
echo $password | sudo -S timeout 35 tcpdump -i $port_0_name ether dst 01:80:c2:00:00:00 -w ${test_function}/${test_function}_captured_${port_0_name}.pcap &
echo $password | sudo -S timeout 35 tcpdump -i $port_1_name ether dst 01:80:c2:00:00:00 -w ${test_function}/${test_function}_captured_${port_1_name}.pcap &
echo $password | sudo -S timeout 35 tcpdump -i $port_2_name ether dst 01:80:c2:00:00:00 -w ${test_function}/${test_function}_captured_${port_2_name}.pcap &
echo $password | sudo -S timeout 35 tcpdump -i $port_3_name ether dst 01:80:c2:00:00:00 -w ${test_function}/${test_function}_captured_${port_3_name}.pcap &
" &

print_info "\tSending Reserved [01:80:c2:00:00:00] Multicast traffic through all interfaces (IF1, IF2, IF3 and IF4)  [parallel process]" | tee -a REPORTS/${func}/${test_function}.out

python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" | tee -a REPORTS/${func}/${test_function}.out
python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f2.json" | tee -a REPORTS/${func}/${test_function}.out
python3 ${sw_dir}soce_generator.py --iface=$IF3 --filejson="SG_FLOWS/${func}/${test_function}_f3.json" | tee -a REPORTS/${func}/${test_function}.out
python3 ${sw_dir}soce_generator.py --iface=$IF4 --filejson="SG_FLOWS/${func}/${test_function}_f4.json" | tee -a REPORTS/${func}/${test_function}.out

sleep 3
