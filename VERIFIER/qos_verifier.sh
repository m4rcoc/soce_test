
#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test QoS.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_qos_1_1_verifier(){

mkdir -p REPORTS/${func}
rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1

print_info "\tReading Flow Statistics Results " | tee -a REPORTS/${func}/${test_function}.out
ssh-keygen -R 192.168.2.146 > /dev/null 2>&1

sleep 8

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}.stats ) " | tee -a REPORTS/${func}/${test_function}.out
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}.stats

export_results
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test QoS.3 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_qos_3_1_verifier(){

mkdir -p REPORTS/${func}

sleep 8

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}.stats

export_results
}

function test_qos_3_2_verifier(){

mkdir -p REPORTS/${func}

sleep 8

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}.stats

export_results
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test QoS.4 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_qos_4_1_verifier(){

mkdir -p REPORTS/${func}

sleep 8

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}.stats

export_results
}

function test_qos_4_2_verifier(){

mkdir -p REPORTS/${func}

sleep 8

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}.stats

export_results
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test QoS.5 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_qos_5_1_verifier(){

mkdir -p REPORTS/${func}

sleep 8

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}.stats

export_results
}

function test_qos_5_2_verifier(){

mkdir -p REPORTS/${func}

sleep 8

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}.stats ) "
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}.stats

export_results
}