#!/bin/bash



#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qav.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qav_1_1_verifier(){

FILE_CSV=VERIFIER/Report/$config_type/${func}/${test_function}_SUMM_STATS.csv

cat << EOF > $FILE_CSV
Filename,Flow Number,Description,Field to verify,Accurancy,Expected
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Loss %,1.0,50
REPORTS/${func}/${test_function}.stats,1,Port 1 of TS should capture only PCP 1 traffic (Flow 2),Tx Frame Rate,1.0,82236.5
EOF

analyze_results_stats $FILE_CSV

print_csv $FILE_CSV

export_results

}  

function test_8021qav_1_2_verifier(){

export_results

} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test 8021Qav.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_8021qav_2_1_verifier(){

export_results

}  
