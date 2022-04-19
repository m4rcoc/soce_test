#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_dynamic_filtering_database_3_1_tsnpcie_verifier(){

cat << EOF > VERIFIER/Report/$config_type/${func}/${test_function}.csv

Type,Condition,Description,Frames to analyze,Filter,Expected

PCAP,1,Total 1502 frames,*,,1502
PCAP,2,Unicast Frames,*,eth.src==00:00:03:00:00:01 and eth.dst==00:aa:aa:aa:aa:aa,1500



EOF

analyze_results VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap VERIFIER/Report/$config_type/${func}/${test_function}.csv

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f Condition,Description,"Frames to analyze",Expected,Results,"PASS/FAIL" VERIFIER/Report/$config_type/${func}/${test_function}.csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}  

