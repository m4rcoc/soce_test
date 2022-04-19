#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_1_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap

num_pkts_pcap_1=$(get_number_of_packets_pcap ${pcap_file_IF1})
num_pkts_pcap_2=$(get_number_of_packets_pcap ${pcap_file_IF2})


cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total Supervision frames associated source MAC 00:aa::01 -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:01,30
${pcap_file_IF1},Total Supervision frames associated source MAC 00:aa::3f -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:3f,30
${pcap_file_IF1},PRP tagged with LAN ID=A (10),*,eth.type==0x88fb and prp.trailer.prp_lan == 10,${num_pkts_pcap_1}

${pcap_file_IF2},Total Supervision frames associated source MAC 00:aa::01 -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:01,30
${pcap_file_IF2},Total Supervision frames associated source MAC 00:aa::3f -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:3f,30
${pcap_file_IF2},PRP tagged with LAN ID=B (11),*,eth.type==0x88fb and prp.trailer.prp_lan == 11,${num_pkts_pcap_2}
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}  


function test_prp_1_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap

num_pkts_pcap_1=$(get_number_of_packets_pcap ${pcap_file_IF1})
num_pkts_pcap_2=$(get_number_of_packets_pcap ${pcap_file_IF2})


cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total Supervision frames associated source MAC 00:aa::01 -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:01,30
${pcap_file_IF1},Total Supervision frames associated source MAC 00:aa::3f -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:3f,30
${pcap_file_IF1},Double tagged -> VLAN + PRP,*,eth.type==0x8100 and vlan.etype==0x88fb,${num_pkts_pcap_1}
${pcap_file_IF1},VLAN tagged (VLAN ID=1 DEI=0 PCP=0),*,vlan.id==1 and vlan.dei==0 and vlan.priority==0,${num_pkts_pcap_1}
${pcap_file_IF1},LAN ID=A (10),*,prp.trailer.prp_lan == 10,${num_pkts_pcap_1}

${pcap_file_IF2},Total Supervision frames associated source MAC 00:aa::01 -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:01,30
${pcap_file_IF2},Total Supervision frames associated source MAC 00:aa::3f -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:3f,30
${pcap_file_IF2},Double tagged -> VLAN + HSR,*,eth.type==0x8100 and vlan.etype==0x88fb,${num_pkts_pcap_2}
${pcap_file_IF2},VLAN tagged (VLAN ID=1 DEI=0 PCP=0),*,vlan.id==1 and vlan.dei==0 and vlan.priority==0,${num_pkts_pcap_2}
${pcap_file_IF2},LAN ID=B (11),*,prp.trailer.prp_lan == 11,${num_pkts_pcap_2}
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}    

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_2_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 1498,*,,1498
${pcap_file_IF1},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1498
${pcap_file_IF1},PRP tagged with LAN ID=A (10),*,prp.trailer.prp1_suffix == 0x88fb and prp.trailer.prp_lan == 10,1498
${pcap_file_IF1},MIN size=66,*,MIN(frame.len)frame.len,66
${pcap_file_IF1},MAX size=1518,*,MAX(frame.len)frame.len,1518
${pcap_file_IF2},Total frames in Redundant B = 1498,*,,1498
${pcap_file_IF2},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1498
${pcap_file_IF2},PRP tagged with LAN ID=B (11),*,prp.trailer.prp1_suffix == 0x88fb and prp.trailer.prp_lan == 11,1498
${pcap_file_IF2},MIN size=66,*,MIN(frame.len)frame.len,66
${pcap_file_IF2},MAX size=1518,*,MAX(frame.len)frame.len,1518
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.3 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_3_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 0,*,,0


${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1500
${pcap_file_IF3},Untagged frames,*,!prp,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1508,*,MAX(frame.len)frame.len,1508
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_3_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 0,*,,0


${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1500
${pcap_file_IF3},Untagged frames,*,!prp,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1508,*,MAX(frame.len)frame.len,1508
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_3_3_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 1,*,,1
${pcap_file_IF3},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1
${pcap_file_IF3},Untagged frames,*,!prp,1
${pcap_file_IF3},Frame size=100-6,*,frame.len==94,1

EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_3_4_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 1,*,,1
${pcap_file_IF3},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1
${pcap_file_IF3},Untagged frames,*,!prp,1
${pcap_file_IF3},Frame size=100-6,*,frame.len==94,1

EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.4 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_4_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Multicast frames,*,(eth.dst[0]&1) && !(eth.dst == ff:ff:ff:ff:ff:ff),1500
${pcap_file_IF3},Untagged frames,*,!prp,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1508,*,MAX(frame.len)frame.len,1508
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

# ${pcap_file_IF3},Multicast frames,*,(eth.dst[0]&1) && !(eth.dst == ff:ff:ff:ff:ff:ff),1

function test_prp_4_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Multicast frames,*,(eth.dst[0]&1) && !(eth.dst == ff:ff:ff:ff:ff:ff),1500
${pcap_file_IF3},Untagged frames,*,!prp,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1508,*,MAX(frame.len)frame.len,1508
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_4_3_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 1,*,,1
${pcap_file_IF3},Multicast frames,*,(eth.dst[0]&1) && !(eth.dst == ff:ff:ff:ff:ff:ff),1
${pcap_file_IF3},Untagged frames,*,!prp,1
${pcap_file_IF3},Frame size=100-6,*,frame.len==94,1

EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_4_4_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 1,*,,1
${pcap_file_IF3},Multicast frames,*,(eth.dst[0]&1) && !(eth.dst == ff:ff:ff:ff:ff:ff),1
${pcap_file_IF3},Untagged frames,*,!prp,1
${pcap_file_IF3},Frame size=100-6,*,frame.len==94,1

EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.5 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_5_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 0,*,,0


${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1500
${pcap_file_IF3},Untagged frames,*,!prp,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1514,*,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_5_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 0,*,,0


${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1500
${pcap_file_IF3},Untagged frames,*,!prp,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1514,*,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_5_3_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Multicast frames,*,(eth.dst[0]&1) && !(eth.dst == ff:ff:ff:ff:ff:ff),1500
${pcap_file_IF3},Untagged frames,*,!prp,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1514,*,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_5_4_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Multicast frames,*,(eth.dst[0]&1) && !(eth.dst == ff:ff:ff:ff:ff:ff),1500
${pcap_file_IF3},Untagged frames,*,!prp,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1514,*,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.7 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_7_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 6,*,,6
${pcap_file_IF3},Untagged frames,*,!prp,6
${pcap_file_IF3},Unicast frames (flow 350ms~2.857fps),*,eth.src==00:AA:AA:AA:AA:01 and eth.dst==00:BB:BB:BB:BB:01,1
${pcap_file_IF3},Unicast frames (flow 390ms~2.564fps),*,eth.src==00:AA:AA:AA:AA:02 and eth.dst==00:BB:BB:BB:BB:02,1
${pcap_file_IF3},Unicast frames (flow 410ms~2.439fps),*,eth.src==00:AA:AA:AA:AA:03 and eth.dst==00:BB:BB:BB:BB:03,2
${pcap_file_IF3},Unicast frames (flow 450ms~2.222fps),*,eth.src==00:AA:AA:AA:AA:04 and eth.dst==00:BB:BB:BB:BB:04,2
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_prp_7_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 0,*,,0

${pcap_file_IF3},Total frames in Interlink = 6,*,,6
${pcap_file_IF3},Untagged frames,*,!prp,6
${pcap_file_IF3},Unicast frames (flow 350ms~2.857fps),*,eth.src==00:AA:AA:AA:AA:01 and eth.dst==00:BB:BB:BB:BB:01,1
${pcap_file_IF3},Unicast frames (flow 390ms~2.564fps),*,eth.src==00:AA:AA:AA:AA:02 and eth.dst==00:BB:BB:BB:BB:02,1
${pcap_file_IF3},Unicast frames (flow 410ms~2.439fps),*,eth.src==00:AA:AA:AA:AA:03 and eth.dst==00:BB:BB:BB:BB:03,2
${pcap_file_IF3},Unicast frames (flow 450ms~2.222fps),*,eth.src==00:AA:AA:AA:AA:04 and eth.dst==00:BB:BB:BB:BB:04,2
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.9 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_9_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 10,*,,10
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,10
${pcap_file_IF3},Wrong PRP suffix,*,!prp,10
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_prp_9_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 10,*,,10
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,10
${pcap_file_IF3},Wrong PRP suffix,*,!prp,10
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.10 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_10_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 10,*,,10
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,10
${pcap_file_IF3},PRP tagged frames,*,prp,10
${pcap_file_IF3},Wrong LSDU size(204),*,prp.trailer.prp_size == 204,10
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_prp_10_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 10,*,,10
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,10
${pcap_file_IF3},PRP tagged frames,*,prp,10
${pcap_file_IF3},Wrong LSDU size(204),*,prp.trailer.prp_size == 204,10
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.11 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_11_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 10,*,,10
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,10
${pcap_file_IF3},PRP untagged frames,*,!prp,10
${pcap_file_IF3},frame size=221-6,*,frame.len == 215,10
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_prp_11_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 10,*,,10
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,10
${pcap_file_IF3},PRP untagged frames,*,!prp,10
${pcap_file_IF3},frame size=221-6,*,frame.len == 215,10
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.13 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_13_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1}, Total P2P Req messages in IF1,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),23
${pcap_file_IF1}, Total P2P Resp messages in IF1,*,(ptp.v2.messageid == 0x3),23

${pcap_file_IF2}, Total P2P Req messages in IF2,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),0
${pcap_file_IF2}, Total P2P Resp messages in IF2,*,(ptp.v2.messageid == 0x3),0

${pcap_file_IF3}, Total P2P Req messages in IF3,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),0
${pcap_file_IF3}, Total P2P Resp messages in IF3,*,(ptp.v2.messageid == 0x3),0
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_prp_13_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1}, Total P2P Req messages in IF1,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),0
${pcap_file_IF1}, Total P2P Resp messages in IF1,*,(ptp.v2.messageid == 0x3),0

${pcap_file_IF2}, Total P2P Req messages in IF2,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),23
${pcap_file_IF2}, Total P2P Resp messages in IF2,*,(ptp.v2.messageid == 0x3),23

${pcap_file_IF3}, Total P2P Req messages in IF3,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),0
${pcap_file_IF3}, Total P2P Resp messages in IF3,*,(ptp.v2.messageid == 0x3),0
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 


function test_prp_13_3_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1}, Total P2P Req messages in IF1,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),0
${pcap_file_IF1}, Total P2P Resp messages in IF1,*,(ptp.v2.messageid == 0x3),0

${pcap_file_IF2}, Total P2P Req messages in IF2,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),0
${pcap_file_IF2}, Total P2P Resp messages in IF2,*,(ptp.v2.messageid == 0x3),0

${pcap_file_IF3}, Total P2P Req messages in IF3,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),23
${pcap_file_IF3}, Total P2P Resp messages in IF3,*,(ptp.v2.messageid == 0x3),23
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.14 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_14_1_verifier(){

export_results
} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test PRP.15 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_prp_15_1_verifier(){

export_results
} 

function test_prp_15_2_verifier(){

export_results
} 

