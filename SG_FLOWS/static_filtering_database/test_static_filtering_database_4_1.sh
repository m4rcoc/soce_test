#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p VERIFIER/Report/$config_type/${func}/${test_function}/
timeout 120 tcpdump -i $IF3 -w VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF3.pcap & 

ssh-keygen -R 192.168.2.146
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<EOF
 cd c:\\Users\\soce\\Documents\\ixia 
 python automated_ixia.py  -t $test_function -m $model -v $version
EOF
touch /usr/local/start
