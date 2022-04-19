#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

# sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip echo $password | sudo -S tcpdump -i $MGT_PORT -w test_static_filtering_database_3_1.pcap

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "echo $password | sudo -S apt install tcpdump"
mkdir -p VERIFIER/Report/$config_type/${func}/${test_function}/

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "echo $password | sudo -S timeout 100 tcpdump -i $MGT_PORT -w test_static_filtering_database_3_2.pcap" &
timeout 120 tcpdump -i $IF3 -w VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF3.pcap & 

ssh-keygen -R 192.168.2.146
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<EOF
 cd c:\\Users\\soce\\Documents\\ixia 
 python automated_ixia.py  -t $test_function -m $model -v $version
EOF
touch /usr/local/start
sleep 60

