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
python automated_ixia.py -t ${test_function} -a start -c
EOF

print_info "\tWaiting 10 seconds..." | tee -a REPORTS/${func}/${test_function}.out

sleep 10

print_info "\tStopping Traffic Capture ( IXIA )" | tee -a REPORTS/${func}/${test_function}.out
ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop_capture
EOF



# case $traffic_control in
# "start")
#     print_info "\tStarting Traffic Generator ( SOCE_GENERATOR / IXIA / CUSTOM SCAPY APP )"
#     ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
#     sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
#     cd c:\\Users\\soce\\Documents\\ixia
#     python automated_ixia.py -t ${test_function} -a start -c
# EOF
   
#     ;;
# "stop")
#     print_info "\tStopping Traffic Generator ( SOCE_GENERATOR / IXIA / CUSTOM SCAPY APP )"
#     ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
#     sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
#     cd c:\\Users\\soce\\Documents\\ixia
#     python automated_ixia.py -t ${test_function} -a stop
# EOF
#     ;;
# "start_capture")
#     print_info "\tStarting Traffic Capture ( IXIA )"
#     ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
#     sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
#     cd c:\\Users\\soce\\Documents\\ixia
#     python automated_ixia.py -t ${test_function} -a start_capture
# EOF
   
#     ;;
# "stop_capture")
#     print_info "\tStopping Traffic Capture ( IXIA )"
#     ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
#     sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
#     cd c:\\Users\\soce\\Documents\\ixia
#     python automated_ixia.py -t ${test_function} -a stop_capture
# EOF
#     ;;    
# "skip")
#     print_info "\tSkipping Traffic Generator ( SOCE_GENERATOR / IXIA / CUSTOM SCAPY APP )"
#     ;;
# esac


