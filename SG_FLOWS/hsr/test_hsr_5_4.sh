#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}

print_info "\tSending (IF1)  <----->  (IF2), 1000 frames, bidirectional, unicast, HSR tagged, VLAN tagged" | tee  REPORTS/${func}/${test_function}.out

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" &
sudo python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < cmds/${test_function}.cmd | tee  REPORTS/${func}/${test_function}.out

