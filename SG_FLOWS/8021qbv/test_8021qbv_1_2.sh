#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}
rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1

print_info "\tStarting Traffic Generator ( SOCE_GENERATOR / IXIA / CUSTOM SCAPY APP )" | tee -a REPORTS/${func}/${test_function}.out
ssh-keygen -R 192.168.2.146 > /dev/null 2>&1


sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF 
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a start
EOF


