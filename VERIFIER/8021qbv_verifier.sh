#!/bin/bash



#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qbv_1_1_verifier(){

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

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
ieee8021qbv get_config_change_time $port_1_config
ieee8021qbv get_oper_configuration $port_1_config
EOF
" | tee -a REPORTS/${func}/${test_function}.out


export_results

}  

function test_8021qbv_1_2_verifier(){
test_8021qbv_1_1_verifier # get IXIA stats and get config change time of $port_1_config
}

function test_8021qbv_1_3_verifier(){
test_8021qbv_1_1_verifier # get IXIA stats and get config change time of $port_1_config
}


function test_8021qbv_1_4_verifier(){

mkdir -p REPORTS/${func}
rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
ieee8021qbv get_config_change_time $port_1_config
ieee8021qbv get_config_pending $port_1_config
EOF
" | tee -a REPORTS/${func}/${test_function}.out

print_info "\tReading Flow Statistics Results " | tee -a REPORTS/${func}/${test_function}.out
ssh-keygen -R 192.168.2.146 > /dev/null 2>&1

sleep 10

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF

print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}_1.stats ) " | tee -a REPORTS/${func}/${test_function}.out
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_1.stats


print_info "\tWaiting 50 seconds ...\n" | tee -a REPORTS/${func}/${test_function}.out

elp=$(($(date +%s)-$(cat cmds/tmp_elapsed_time.cmd)))
time=$((60-$elp))
#print_info "time=$time"
sleep $time

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a clear
EOF

sleep 15

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF
sleep 1
print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}_2.stats ) " | tee -a REPORTS/${func}/${test_function}.out
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_2.stats

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
ieee8021qbv get_config_change_time $port_1_config
ieee8021qbv get_config_pending $port_1_config
EOF
" | tee -a REPORTS/${func}/${test_function}.out

cat REPORTS/${func}/${test_function}_1.stats REPORTS/${func}/${test_function}_2.stats > REPORTS/${func}/${test_function}.stats

export_results    

}




#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

# function test_8021qbv_2_1_verifier(){

# test_8021qbv_1_1_verifier # get IXIA stats and get config change time of $port_1_config

# }  


function test_8021qbv_2_2_verifier(){
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


print_info "\tGetting configuration change time, config pending, admin config and oper config (saved in REPORTS/${func}/${test_function}.out ) " | tee -a REPORTS/${func}/${test_function}.out
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
ieee8021qbv get_config_change_time $port_1_config
ieee8021qbv get_config_pending $port_1_config
ieee8021qbv get_admin_configuration $port_1_config
ieee8021qbv get_oper_configuration $port_1_config
EOF
" | tee -a REPORTS/${func}/${test_function}.out

export_results
}

function test_8021qbv_2_3_verifier(){
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
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_1.stats


print_info "\tGetting configuration change time, config pending, admin config and oper config (saved in REPORTS/${func}/${test_function}.out ) " | tee -a REPORTS/${func}/${test_function}.out
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
ieee8021qbv get_config_change_time $port_1_config
ieee8021qbv get_config_pending $port_1_config
ieee8021qbv get_admin_configuration $port_1_config
ieee8021qbv get_oper_configuration $port_1_config
EOF
" | tee -a REPORTS/${func}/${test_function}.out

print_info "\tWaiting 100 seconds ...\n" | tee -a REPORTS/${func}/${test_function}.out

elp=$(($(date +%s)-$(cat cmds/tmp_elapsed_time)))
time=$((105-$elp))
sleep $time

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a clear
EOF

sleep 15

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stats
EOF
sleep 0.5
print_info "\tGetting Flow statistics report file from IXIA VM (saved in REPORTS/${func}/${test_function}_2.stats ) " | tee -a REPORTS/${func}/${test_function}.out
sshpass -p soce scp -o StrictHostKeyChecking=no -r soce@192.168.2.146:c:\\test\\reports\\${test_function}.txt REPORTS/${func}/${test_function}_2.stats

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
ieee8021qbv get_config_pending $port_1_config
ieee8021qbv get_admin_configuration $port_1_config
ieee8021qbv get_oper_configuration $port_1_config
EOF
EOF
" | tee -a REPORTS/${func}/${test_function}.out

cat REPORTS/${func}/${test_function}_1.stats REPORTS/${func}/${test_function}_2.stats > REPORTS/${func}/${test_function}.stats

export_results
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.3 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qbv_3_1_verifier(){

export_results

}  

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.4 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

# cat << EOF > $FILE_CSV
# Filename,Flow Number,Description,Field to verify,Accurancy,Expected
# REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,0
# REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
# REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
# REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
# REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
# REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
# REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
# REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
# EOF

function test_8021qbv_4_1_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,0
REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 0 traffic (Flow 1),Loss %,0.5,100
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}

function test_8021qbv_4_2_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,0.5,0
REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,0.5,100
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}

function test_8021qbv_4_3_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 2 traffic (Flow 3),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 2 traffic (Flow 3),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 2 traffic (Flow 3),Loss %,0.5,0
REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 2 traffic (Flow 3),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 2 traffic (Flow 3),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 2 traffic (Flow 3),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 2 traffic (Flow 3),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 2 traffic (Flow 3),Loss %,0.5,100
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}  

function test_8021qbv_4_4_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 3 traffic (Flow 4),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 3 traffic (Flow 4),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 3 traffic (Flow 4),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 3 traffic (Flow 4),Loss %,0.5,0
REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 3 traffic (Flow 4),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 3 traffic (Flow 4),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 3 traffic (Flow 4),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 3 traffic (Flow 4),Loss %,0.5,100
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}  

function test_8021qbv_4_5_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 4 traffic (Flow 5),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 4 traffic (Flow 5),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 4 traffic (Flow 5),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 4 traffic (Flow 5),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 4 traffic (Flow 5),Loss %,0.5,0
REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 4 traffic (Flow 5),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 4 traffic (Flow 5),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 4 traffic (Flow 5),Loss %,0.5,100
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}  

function test_8021qbv_4_6_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 5 traffic (Flow 6),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 5 traffic (Flow 6),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 5 traffic (Flow 6),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 5 traffic (Flow 6),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 5 traffic (Flow 6),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 5 traffic (Flow 6),Loss %,0.5,0
REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 5 traffic (Flow 6),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 5 traffic (Flow 6),Loss %,0.5,100
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}  

function test_8021qbv_4_7_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 6 traffic (Flow 7),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 6 traffic (Flow 7),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 6 traffic (Flow 7),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 6 traffic (Flow 7),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 6 traffic (Flow 7),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 6 traffic (Flow 7),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 6 traffic (Flow 7),Loss %,0.5,0
REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 6 traffic (Flow 7),Loss %,0.5,100
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}

function test_8021qbv_4_8_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 7 traffic (Flow 8),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,2,Port 1 of TS should capture only PCP 7 traffic (Flow 8),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,3,Port 1 of TS should capture only PCP 7 traffic (Flow 8),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,4,Port 1 of TS should capture only PCP 7 traffic (Flow 8),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,5,Port 1 of TS should capture only PCP 7 traffic (Flow 8),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,6,Port 1 of TS should capture only PCP 7 traffic (Flow 8),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,7,Port 1 of TS should capture only PCP 7 traffic (Flow 8),Loss %,0.5,100
REPORTS/${func}/${test_function}.stats,8,Port 1 of TS should capture only PCP 7 traffic (Flow 8),Loss %,0.5,0
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}  

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.5 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qbv_5_1_verifier(){

export_results

}  

function test_8021qbv_5_2_verifier(){

export_results

} 

function test_8021qbv_5_3_verifier(){

export_results

} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.6 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qbv_6_1_verifier(){

ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

}  

function test_8021qbv_6_2_verifier(){

ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

} 

function test_8021qbv_6_3_verifier(){

ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

} 

function test_8021qbv_6_4_verifier(){

ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

}  

function test_8021qbv_6_5_verifier(){

ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

} 

function test_8021qbv_6_6_verifier(){

ssh-keygen -R 192.168.2.146 > /dev/null 2>&1
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

} 

function test_8021qbv_6_7_verifier(){

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

}  

function test_8021qbv_6_8_verifier(){

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

} 

function test_8021qbv_6_9_verifier(){

sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<-EOF
cd c:\\Users\\soce\\Documents\\ixia
python automated_ixia.py -t ${test_function} -a stop
EOF

export_results

} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.7 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qbv_7_1_verifier(){

export_results

}  

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.8 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qbv_8_1_verifier(){

export_results

}  

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qbv.10 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qbv_10_1_verifier(){

export_results

}  

function test_8021qbv_10_2_verifier(){

export_results

} 

function test_8021qbv_10_3_verifier(){

export_results

} 