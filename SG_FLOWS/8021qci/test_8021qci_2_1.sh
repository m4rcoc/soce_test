#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}


sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a start
EOF

# print_info "\tReading Flow Statistics Results "
# ssh-keygen -R 192.168.2.146 > /dev/null 2>&1

# sleep 8

# sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
# cd c:\\Users\\soce\\Documents\\ixia
# python automated_ixia.py -t ${test_function} -a stats
# EOF

# print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}.stats ) "
# sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}.stats


print_info "\tReading Flow Statistics Results "
ssh-keygen -R 192.168.2.146 > /dev/null 2>&1

sleep 8

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}_1.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_1.stats


print_info "\tClear Flow statistics on IXIA "
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a clear
EOF

sleep 8

print_info "\tReading Flow Statistics Results "
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

sleep 8

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}_2.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_2.stats

rm -r REPORTS/${func}/${test_function}.out
print_info "\tReset StreamBlockedDutToOversizeFrame to 0" | tee -a REPORTS/${func}/${test_function}.out
fast_soce_cli "
ieee8021qci reset_stream_blocked_due_to_oversize_frame SWITCH 0
" | tee -a REPORTS/${func}/${test_function}.out


print_info "\tRe-launch Ixia Traffic Flows "

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a start
EOF

print_info "\tClear Flow statistics on IXIA "
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a clear
EOF

sleep 8

print_info "\tReading Flow Statistics Results "
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

sleep 8

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}_3.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_3.stats
