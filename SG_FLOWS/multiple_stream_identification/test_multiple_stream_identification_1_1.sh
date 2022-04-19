#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}

python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f3.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f4.json"
sleep 1


rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1
print_info "\tReading Stream Identification statistics:" | tee -a REPORTS/${func}/${test_function}.out
fast_soce_cli "
stream_identification get_per_port_per_stream_statistics $port_0_config 0
stream_identification get_per_port_per_stream_statistics $port_0_config 1
stream_identification get_per_port_per_stream_statistics $port_0_config 2
stream_identification get_per_port_per_stream_statistics $port_0_config 3
stream_identification get_per_port_statistics $port_0_config
" | tee -a REPORTS/${func}/${test_function}.out





# print_info "\tLaunching Traffic from IXIA " | tee -a REPORTS/${func}/${test_function}.out
# ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
# sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
# cd c:\\Users\\soce\\Documents\\ixia
# python automated_ixia.py -t ${test_function} -a start
# EOF

# print_info "\tReading Flow Statistics Results "

# sleep 8

# sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
# cd c:\\Users\\soce\\Documents\\ixia
# python automated_ixia.py -t ${test_function} -a stats
# EOF

# print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}_1.stats ) "
# sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_1.stats

# print_info "\tReading PSFP Statistics from Filter ID [0-3]" | tee -a REPORTS/${func}/${test_function}.out
# fast_soce_cli "
# ieee8021qci get_psfp_statistics SWITCH 0
# ieee8021qci get_psfp_statistics SWITCH 1
# ieee8021qci get_psfp_statistics SWITCH 2

# " | tee -a REPORTS/${func}/${test_function}.out

# print_info "\tClosing Gate ID [0-3]" | tee -a REPORTS/${func}/${test_function}.out
# fast_soce_cli "
# ieee8021qci set_stream_gate_table_entry SWITCH 0 enabled 0 disabled 7
# ieee8021qci set_stream_gate_table_entry SWITCH 1 enabled 0 disabled 7
# ieee8021qci set_stream_gate_table_entry SWITCH 2 enabled 0 disabled 7

# " | tee -a REPORTS/${func}/${test_function}.out

# print_info "\tRe-Launching Traffic from IXIA " | tee -a REPORTS/${func}/${test_function}.out
# sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
# cd c:\\Users\\soce\\Documents\\ixia
# python automated_ixia.py -t ${test_function} -a start
# EOF

# print_info "\tReading Flow Statistics Results "

# sleep 8

# sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
# cd c:\\Users\\soce\\Documents\\ixia
# python automated_ixia.py -t ${test_function} -a stats
# EOF

# print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}_2.stats ) "
# sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_2.stats

# print_info "\tReading PSFP Statistics from Filter ID [0-3]" | tee -a REPORTS/${func}/${test_function}.out
# fast_soce_cli "
# ieee8021qci get_psfp_statistics SWITCH 0
# ieee8021qci get_psfp_statistics SWITCH 1
# ieee8021qci get_psfp_statistics SWITCH 2

# " | tee -a REPORTS/${func}/${test_function}.out
