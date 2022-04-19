#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_1_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap

num_pkts_pcap_1=$(get_number_of_packets_pcap ${pcap_file_IF1})
num_pkts_pcap_2=$(get_number_of_packets_pcap ${pcap_file_IF2})


cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total Supervision frames associated source MAC 00:aa::01 -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:01,30
${pcap_file_IF1},Total Supervision frames associated source MAC 00:aa::3f -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:3f,30
${pcap_file_IF1},HSR tagged with LAN ID=A (0),*,eth.type==0x892f and hsr.laneid==0,${num_pkts_pcap_1}

${pcap_file_IF2},Total Supervision frames associated source MAC 00:aa::01 -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:01,30
${pcap_file_IF2},Total Supervision frames associated source MAC 00:aa::3f -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:3f,30
${pcap_file_IF2},HSR tagged with LAN ID=B (1),*,eth.type==0x892f and hsr.laneid==1,${num_pkts_pcap_2}
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}  


function test_hsr_1_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap

num_pkts_pcap_1=$(get_number_of_packets_pcap ${pcap_file_IF1})
num_pkts_pcap_2=$(get_number_of_packets_pcap ${pcap_file_IF2})


cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total Supervision frames associated source MAC 00:aa::01 -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:01,30
${pcap_file_IF1},Total Supervision frames associated source MAC 00:aa::3f -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:3f,30
${pcap_file_IF1},Double tagged -> VLAN + HSR,*,eth.type==0x8100 and vlan.etype==0x892f,${num_pkts_pcap_1}
${pcap_file_IF1},VLAN tagged (VLAN ID=1 DEI=0 PCP=0),*,vlan.id==1 and vlan.dei==0 and vlan.priority==0,${num_pkts_pcap_1}
${pcap_file_IF1},LAN ID=A (0),*,hsr.laneid==0,${num_pkts_pcap_1}

${pcap_file_IF2},Total Supervision frames associated source MAC 00:aa::01 -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:01,30
${pcap_file_IF2},Total Supervision frames associated source MAC 00:aa::3f -> 60s/2fps=30f,*,hsr_prp_supervision.source_mac_address==00:aa:aa:aa:aa:3f,30
${pcap_file_IF2},Double tagged -> VLAN + HSR,*,eth.type==0x8100 and vlan.etype==0x892f,${num_pkts_pcap_2}
${pcap_file_IF2},VLAN tagged (VLAN ID=1 DEI=0 PCP=0),*,vlan.id==1 and vlan.dei==0 and vlan.priority==0,${num_pkts_pcap_2}
${pcap_file_IF2},LAN ID=B (1),*,hsr.laneid==1,${num_pkts_pcap_2}
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}    

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_2_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 1498,*,,1498
${pcap_file_IF1},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1498
${pcap_file_IF1},HSR tagged with LAN ID=A (0),*,eth.type==0x892f and hsr.laneid==0,1498
${pcap_file_IF1},MIN size=66,*,MIN(frame.len)frame.len,66
${pcap_file_IF1},MAX size=1518,*,MAX(frame.len)frame.len,1518
${pcap_file_IF2},Total frames in Redundant B = 1498,*,,1498
${pcap_file_IF2},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1498
${pcap_file_IF2},HSR tagged with LAN ID=B (1),*,eth.type==0x892f and hsr.laneid==1,1498
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
#  [VERIFIER] Test HSR.3 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_3_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 1500,*,,1500
${pcap_file_IF2},Multicast frames (192.168.100.100 -> 224.1.2.3),*,ip.src==192.168.100.100 and ip.dst==224.1.2.3,1500
${pcap_file_IF2},HSR tagged with LAN ID=A (0),*,eth.type==0x892f and hsr.laneid==0,1500
${pcap_file_IF2},MIN size=66,*,MIN(frame.len)frame.len,66
${pcap_file_IF2},MAX size=1514,*,MAX(frame.len)frame.len,1514

${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Multicast frames (192.168.100.100 -> 224.1.2.3),*,ip.src==192.168.100.100 and ip.dst==224.1.2.3,1500
${pcap_file_IF3},Untagged frames,*,eth.type==0x0800,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1508,*,MAX(frame.len)frame.len,1508
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_hsr_3_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 1500,*,,1500
${pcap_file_IF1},Multicast frames (192.168.100.100 -> 224.1.2.3),*,ip.src==192.168.100.100 and ip.dst==224.1.2.3,1500
${pcap_file_IF1},HSR tagged with LAN ID=B (1),*,eth.type==0x892f and hsr.laneid==1,1500
${pcap_file_IF1},MIN size=66,*,MIN(frame.len)frame.len,66
${pcap_file_IF1},MAX size=1514,*,MAX(frame.len)frame.len,1514

${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Multicast frames (192.168.100.100 -> 224.1.2.3),*,ip.src==192.168.100.100 and ip.dst==224.1.2.3,1500
${pcap_file_IF3},Untagged frames,*,eth.type==0x0800,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1508,*,MAX(frame.len)frame.len,1508
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_hsr_3_3_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 1,*,,1
${pcap_file_IF2},Multicast frames (192.168.100.100 -> 224.1.2.3),*,ip.src==192.168.100.100 and ip.dst==224.1.2.3,1
${pcap_file_IF2},HSR tagged with LAN ID=A (0),*,eth.type==0x892f and hsr.laneid==0,1
${pcap_file_IF2},Frame length=100,*,frame.len==100,1

${pcap_file_IF3},Total frames in Interlink = 1,*,,1
${pcap_file_IF3},Multicast frames (192.168.100.100 -> 224.1.2.3),*,ip.src==192.168.100.100 and ip.dst==224.1.2.3,1
${pcap_file_IF3},Untagged frames,*,eth.type==0x0800,1
${pcap_file_IF3},Frame length=94,*,frame.len==94,1
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_hsr_3_4_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant B = 1,*,,1
${pcap_file_IF1},Multicast frames (192.168.100.100 -> 224.1.2.3),*,ip.src==192.168.100.100 and ip.dst==224.1.2.3,1
${pcap_file_IF1},HSR tagged with LAN ID=B (1),*,eth.type==0x892f and hsr.laneid==1,1
${pcap_file_IF1},Frame length=100,*,frame.len==100,1

${pcap_file_IF3},Total frames in Interlink = 1,*,,1
${pcap_file_IF3},Multicast frames (192.168.100.100 -> 224.1.2.3),*,ip.src==192.168.100.100 and ip.dst==224.1.2.3,1
${pcap_file_IF3},Untagged frames,*,eth.type==0x0800,1
${pcap_file_IF3},Frame length=94,*,frame.len==94,1
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.4 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_4_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 0,*,,0
${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Unicast frames,*,eth.dst==00:AA:AA:AA:AA:AA and eth.src==00:BB:BB:BB:BB:BB,1500
${pcap_file_IF3},Untagged frames,*,eth.type==0xffff,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1508,*,MAX(frame.len)frame.len,1508
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_hsr_4_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 0,*,,0
${pcap_file_IF3},Total frames in Interlink = 1500,*,,1500
${pcap_file_IF3},Unicast frames,*,eth.dst==00:CC:CC:CC:CC:CC and eth.src==00:DD:DD:DD:DD:DD,1500
${pcap_file_IF3},Untagged frames,*,eth.type==0xffff,1500
${pcap_file_IF3},MIN size=60,*,MIN(frame.len)frame.len,60
${pcap_file_IF3},MAX size=1508,*,MAX(frame.len)frame.len,1508
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_hsr_4_3_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF2},Total frames in Redundant B = 1500,*,,1500
${pcap_file_IF2},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1500
${pcap_file_IF2},HSR tagged with LAN ID=A (0),*,eth.type==0x892f and hsr.laneid==0,1500
${pcap_file_IF2},MIN size=66,*,MIN(frame.len)frame.len,66
${pcap_file_IF2},MAX size=1514,*,MAX(frame.len)frame.len,1514
${pcap_file_IF3},Total frames in Interlink = 0,*,,0
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_hsr_4_4_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1},Total frames in Redundant A = 1500,*,,1500
${pcap_file_IF1},Unicast frames,*,eth.src==00:AA:AA:AA:AA:AA and eth.dst==00:BB:BB:BB:BB:BB,1500
${pcap_file_IF1},HSR tagged with LAN ID=B (1),*,eth.type==0x892f and hsr.laneid==1,1500
${pcap_file_IF1},MIN size=66,*,MIN(frame.len)frame.len,66
${pcap_file_IF1},MAX size=1514,*,MAX(frame.len)frame.len,1514
${pcap_file_IF3},Total frames in Interlink = 0,*,,0
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.5 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_5_1_verifier(){

export_results
} 

function test_hsr_5_2_verifier(){

export_results
} 

function test_hsr_5_3_verifier(){

export_results
} 

function test_hsr_5_4_verifier(){

export_results
} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.6 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function get_node_table(){

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
hsr_prp_node_table reset_counters
hsr_prp_node_table read
EOF
" | tee -a REPORTS/${func}/${test_function}.out
}

function test_hsr_6_1_verifier(){

sleep 2

mkdir -p REPORTS/${func}
print_info "\tNetwork Nodes Table:" | tee REPORTS/${func}/${test_function}.out
get_node_table | tee -a REPORTS/${func}/${test_function}.out

export_results
} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.7 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_7_1_verifier(){

export_results
} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.8 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_8_1_verifier(){

export_results
} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.9 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_9_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 11,*,,11
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,11
${pcap_file_IF3},Wrong HSR ethertype,*,eth.type==0x892e,11
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.10 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_10_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 20,*,,20
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,20
${pcap_file_IF3},Not HSR tagged,*,!hsr,20
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.11 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_11_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF3},Total frames in Interlink = 20,*,,20
${pcap_file_IF3},Broadcast frames,*,eth.dst==FF:FF:FF:FF:FF:FF,20
${pcap_file_IF3},Not HSR tagged,*,!hsr,20
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.12 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_12_1_verifier(){

export_results
} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.13 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_13_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1}, Total P2P Req messages in IF1,*,(ptp.v2.messageid == 0x2) && (eth.src == 00:0a:dc:d9:42:a0),10
${pcap_file_IF1}, Total P2P Resp messages in IF1,*,(ptp.v2.messageid == 0x3),10

${pcap_file_IF2}, Total P2P Req messages in IF2,*,(ptp.v2.messageid == 0x2) && (eth.src == 00:0a:dc:d9:42:a0),10
${pcap_file_IF2}, Total P2P Resp messages in IF2,*,(ptp.v2.messageid == 0x3),0

${pcap_file_IF3}, Total P2P Req messages in IF3,*,(ptp.v2.messageid == 0x2) && (eth.src == 00:0a:dc:d9:42:a0),0
${pcap_file_IF3}, Total P2P Resp messages in IF3,*,(ptp.v2.messageid == 0x3),0
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_hsr_13_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file_IF1}, Total P2P Req messages in IF1,*,(ptp.v2.messageid == 0x2) && (eth.src == 00:0a:dc:d9:42:a0),10
${pcap_file_IF1}, Total P2P Resp messages in IF1,*,(ptp.v2.messageid == 0x3),0

${pcap_file_IF2}, Total P2P Req messages in IF2,*,(ptp.v2.messageid == 0x2) && (eth.src == 00:0a:dc:d9:42:a0),10
${pcap_file_IF2}, Total P2P Resp messages in IF2,*,(ptp.v2.messageid == 0x3),10

${pcap_file_IF3}, Total P2P Req messages in IF3,*,(ptp.v2.messageid == 0x2) && (eth.src == 00:0a:dc:d9:42:a0),0
${pcap_file_IF3}, Total P2P Resp messages in IF3,*,(ptp.v2.messageid == 0x3),0
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_hsr_13_3_verifier(){

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

${pcap_file_IF3}, Total P2P Req messages in IF3,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),10
${pcap_file_IF3}, Total P2P Resp messages in IF3,*,(ptp.v2.messageid == 0x3),10
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.14 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_14_1_verifier(){

# csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
# pcap_file_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
# pcap_file_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
# pcap_file_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap

# cat << EOF > $csv_file

# PCAP file path,Description,Frames to analyze,Filter,Expected

# ${pcap_file_IF1}, Total P2P Req messages in IF1,*,(ptp.v2.messageid == 0x2) && (eth.src == 00:0a:dc:d9:42:a0),10
# ${pcap_file_IF1}, Total P2P Resp messages in IF1,*,(ptp.v2.messageid == 0x3),10

# ${pcap_file_IF2}, Total P2P Req messages in IF2,*,(ptp.v2.messageid == 0x2) && (eth.src == 00:0a:dc:d9:42:a0),10
# ${pcap_file_IF2}, Total P2P Resp messages in IF2,*,(ptp.v2.messageid == 0x3),10

# ${pcap_file_IF3}, Total P2P Req messages in IF3,*,(ptp.v2.messageid == 0x2) && (eth.src == ec:46:70:00:7e:a2),10
# ${pcap_file_IF3}, Total P2P Resp messages in IF3,*,(ptp.v2.messageid == 0x3),10
# EOF

# analyze_results_pcap $csv_file

# mkdir -p REPORTS/${func}

# mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

# cat REPORTS/${func}/${test_function}.rpt 

export_results
} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test HSR.15 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_hsr_15_1_verifier(){

export_results
} 

function test_hsr_15_2_verifier(){

export_results
} 