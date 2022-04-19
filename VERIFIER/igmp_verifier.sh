#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test IGMP.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_igmp_1_1_verifier(){

export_results

}  


function test_igmp_1_2_verifier(){

export_results

}    

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test IGMP.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_igmp_2_1_verifier(){

csv_file=VERIFIER/Report/${config_type}/${func}/${test_function}/${test_function}.csv
pcap_file=VERIFIER/Report/${config_type}/${func}/$test_function/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 0 frames,*,,0
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}

function test_igmp_2_2_verifier(){

csv_file=VERIFIER/Report/${config_type}/${func}/${test_function}/${test_function}.csv
pcap_file=VERIFIER/Report/${config_type}/${func}/$test_function/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 1500 frames,*,,1500
${pcap_file},Multicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==01:00:5E:01:02:03,1500
${pcap_file},MIN size=64,*,MIN(frame.len)frame.len,64
${pcap_file},MAX size=1514,*,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}

function test_igmp_2_3_verifier(){

export_results

}

function test_igmp_2_4_verifier(){

export_results

}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test IGMP.3 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_igmp_3_1_verifier(){

export_results

} 

function test_igmp_3_2_verifier(){

export_results

} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test IGMP.4 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_igmp_4_1_verifier(){

export_results

} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test IGMP.5 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_igmp_5_1_verifier(){

export_results

} 

function test_igmp_5_2_verifier(){

export_results

} 

function test_igmp_5_3_verifier(){

export_results

} 

function test_igmp_5_4_verifier(){

export_results

} 

function test_igmp_5_5_verifier(){

export_results

} 

function test_igmp_5_6_verifier(){

export_results

} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test IGMP.6 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_igmp_6_1_verifier(){

export_results

}

function test_igmp_6_2_verifier(){

export_results

} 


