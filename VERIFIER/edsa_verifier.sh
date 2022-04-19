#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test EDSA.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_edsa_1_1_verifier(){

mgt_cap=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}.pcap

mkdir -p "${mgt_cap%/*}" && touch $mgt_cap

sshpass -p $password scp -o StrictHostKeyChecking=no -r $username@$ip:/home/$username/${test_function}.pcap VERIFIER/Report/$config_type/${func}/$test_function/${test_function}.pcap
cat << EOF > VERIFIER/Report/$config_type/${func}/$test_function/${test_function}.csv
Type,Condition,Description,Frames to analyze,Filter,Expected
PCAP,1,Total 1500 frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==01:80:c2:00:00:00,1500
PCAP,2,Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==01:80:c2:00:00:00,1500
EOF

analyze_results_pcap VERIFIER/Report/$config_type/${func}/$test_function/${test_function}.pcap VERIFIER/Report/$config_type/${func}/$test_function/${test_function}.csv


print_csv VERIFIER/Report/$config_type/${func}/$test_function/${test_function}.csv
mlr --icsv --opprint cut -f Condition,Description,"Frames to analyze",Expected,Results,"PASS/FAIL" VERIFIER/Report/$config_type/${func}/$test_function/${test_function}.csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 
export_results

} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test EDSA.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_edsa_2_1_verifier(){

export_results

}  

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test EDSA.3 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_edsa_3_1_verifier(){

sshpass -p $password scp -o StrictHostKeyChecking=no -r $username@$ip:/home/$username/${test_function}/ VERIFIER/Report/$config_type/${func}/
export_results

}  

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test EDSA.4 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_edsa_4_1_verifier(){

export_results

}  