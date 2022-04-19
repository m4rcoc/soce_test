#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_vlan_1_1_verifier(){


csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 4500 frames,*,,4500
${pcap_file},Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:bb:bb:bb:bb:bb,4500
${pcap_file},First 1500 frames -> VLAN tagged (VID=100 PRI=0 DEI=0),frame.number<=1500,vlan.id==100 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},First 1500 frames -> MIN size=68,frame.number<=1500,MIN(frame.len)frame.len,68
${pcap_file},First 1500 frames -> MAX size=1518,frame.number<=1500,MAX(frame.len)frame.len,1518

${pcap_file},Second 1500 frames -> VLAN tagged (VID=100 PRI=0 DEI=0),frame.number>1500 and frame.number<=3000,vlan.id==100 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},Second 1500 frames -> MIN size=64,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,64
${pcap_file},Second 1500 frames -> MAX size=1514,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1514

${pcap_file},Last 1500 frames -> VLAN tagged (VID=200 PRI=0 DEI=0),frame.number>3000 and frame.number<=4500,vlan.id==200 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},Last 1500 frames -> MIN size=64,frame.number>3000 and frame.number<=4500,MIN(frame.len)frame.len,64
${pcap_file},Last 1500 frames -> MAX size=1514,frame.number>3000 and frame.number<=4500,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}  



function test_vlan_1_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 1500 frames,*,,1500
${pcap_file},Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:bb:bb:bb:bb:bb,1500
${pcap_file},VLAN tagged (VID=200 PRI=0 DEI=0),*,vlan.id==200 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},MIN size=64,*,MIN(frame.len)frame.len,64
${pcap_file},MAX size=1514,*,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}    

function test_vlan_1_3_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000
${pcap_file},Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:bb:bb:bb:bb:bb,3000

${pcap_file},First 1500 frames -> VLAN tagged (VID=100 PRI=0 DEI=0),frame.number<=1500,vlan.id==100 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},First 1500 frames -> MIN size=68,frame.number<=1500,MIN(frame.len)frame.len,68
${pcap_file},First 1500 frames -> MAX size=1518,frame.number<=1500,MAX(frame.len)frame.len,1518

${pcap_file},Second 1500 frames -> VLAN tagged (VID=100 PRI=0 DEI=0),frame.number>1500 and frame.number<=3000,vlan.id==0 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},Second 1500 frames -> MIN size=64,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,64
${pcap_file},Second 1500 frames -> MAX size=1514,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}
 

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_vlan_2_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000
${pcap_file},Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:bb:bb:bb:bb:bb,3000

${pcap_file},First 1500 frames -> VLAN tagged (VID=200 PRI=0 DEI=0),frame.number<=1500,vlan.id==200 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},First 1500 frames -> MIN size=64,frame.number<=1500,MIN(frame.len)frame.len,64
${pcap_file},First 1500 frames -> MAX size=1514,frame.number<=1500,MAX(frame.len)frame.len,1514

${pcap_file},Second 1500 frames -> VLAN tagged (VID=300 PRI=0 DEI=0),frame.number>1500 and frame.number<=3000,vlan.id==300 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},Second 1500 frames -> MIN size=64,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,64
${pcap_file},Second 1500 frames -> MAX size=1514,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}

function test_vlan_2_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 1500 frames,*,,1500
${pcap_file},Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:bb:bb:bb:bb:bb,1500

${pcap_file},VLAN tagged (VID=200 PRI=0 DEI=0),frame.number<=1500,vlan.id==200 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},MIN size=64,*,MIN(frame.len)frame.len,64
${pcap_file},MAX size=1514,*,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.3 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_vlan_3_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000

${pcap_file},First 1500 frames -> MAC dst=00:00:00:00:00:01 and untagged,frame.number<=1500,eth.dst==00:00:00:00:00:01 && !(vlan),1500
${pcap_file},First 1500 frames -> MIN size=64,frame.number<=1500,MIN(frame.len)frame.len,64
${pcap_file},First 1500 frames -> MAX size=1514,frame.number<=1500,MAX(frame.len)frame.len,1514

${pcap_file},Second 1500 frames -> MAC dst=00:00:00:00:00:02 and untagged,frame.number>1500 and frame.number<=3000,eth.dst==00:00:00:00:00:02 && !(vlan),1500
${pcap_file},Second 1500 frames -> MIN size=60,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,60
${pcap_file},Second 1500 frames -> MAX size=1510,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1510
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.4 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_vlan_4_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000

${pcap_file},First 1500 frames -> MAC dst=00:00:00:00:00:01 and VLAN tagged (VID=100 PRI=0 DEI=0),frame.number<=1500,eth.dst==00:00:00:00:00:01 && (vlan.id==100 && vlan.dei==0 && vlan.priority==0),1500
${pcap_file},First 1500 frames -> MIN size=68,frame.number<=1500,MIN(frame.len)frame.len,68
${pcap_file},First 1500 frames -> MAX size=1518,frame.number<=1500,MAX(frame.len)frame.len,1518

${pcap_file},Second 1500 frames -> MAC dst=00:00:00:00:00:02 and VLAN tagged (VID=100 PRI=0 DEI=0),frame.number>1500 and frame.number<=3000,eth.dst==00:00:00:00:00:02 && (vlan.id==100 && vlan.dei==0 && vlan.priority==0),1500
${pcap_file},Second 1500 frames -> MIN size=64,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,64
${pcap_file},Second 1500 frames -> MAX size=1514,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 

function test_vlan_4_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000

${pcap_file},First 1500 frames -> MAC dst=00:00:00:00:00:01 and VLAN tagged (VID=100 PRI=0 DEI=0),frame.number<=1500,eth.dst==00:00:00:00:00:01 && (vlan.id==100 && vlan.dei==0 && vlan.priority==0),1500
${pcap_file},First 1500 frames -> MIN size=68,frame.number<=1500,MIN(frame.len)frame.len,68
${pcap_file},First 1500 frames -> MAX size=1518,frame.number<=1500,MAX(frame.len)frame.len,1518

${pcap_file},Second 1500 frames -> MAC dst=00:00:00:00:00:02 and VLAN tagged (VID=100 PRI=0 DEI=0),frame.number>1500 and frame.number<=3000,eth.dst==00:00:00:00:00:02 && (vlan.id==100 && vlan.dei==0 && vlan.priority==0),1500
${pcap_file},Second 1500 frames -> MIN size=64,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,64
${pcap_file},Second 1500 frames -> MAX size=1514,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results

} 



#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.5 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_vlan_5_1_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000

${pcap_file},First 1500 frames -> MAC dst=00:00:00:00:00:01 and VLAN tagged (VID=100 PRI=0 DEI=0),frame.number<=1500,eth.dst==00:00:00:00:00:01 && (vlan.id==100 && vlan.dei==0 && vlan.priority==0),1500
${pcap_file},First 1500 frames -> MIN size=68,frame.number<=1500,MIN(frame.len)frame.len,68
${pcap_file},First 1500 frames -> MAX size=1518,frame.number<=1500,MAX(frame.len)frame.len,1518

${pcap_file},Second 1500 frames -> MAC dst=00:00:00:00:00:02 and VLAN tagged (VID=100 PRI=0 DEI=0),frame.number>1500 and frame.number<=3000,eth.dst==00:00:00:00:00:02 && (vlan.id==100 && vlan.dei==0 && vlan.priority==0),1500
${pcap_file},Second 1500 frames -> MIN size=64,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,64
${pcap_file},Second 1500 frames -> MAX size=1514,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_vlan_5_2_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000

${pcap_file},First 1500 frames -> MAC dst=00:00:00:00:00:01 and VLAN tagged (VID=100 PRI=0 DEI=0),frame.number<=1500,eth.dst==00:00:00:00:00:01 && (vlan.id==100 && vlan.dei==0 && vlan.priority==0),1500
${pcap_file},First 1500 frames -> MIN size=68,frame.number<=1500,MIN(frame.len)frame.len,68
${pcap_file},First 1500 frames -> MAX size=1518,frame.number<=1500,MAX(frame.len)frame.len,1518

${pcap_file},Second 1500 frames -> MAC dst=00:00:00:00:00:02 and VLAN tagged (VID=100 PRI=0 DEI=0),frame.number>1500 and frame.number<=3000,eth.dst==00:00:00:00:00:02 && (vlan.id==100 && vlan.dei==0 && vlan.priority==0),1500
${pcap_file},Second 1500 frames -> MIN size=64,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,64
${pcap_file},Second 1500 frames -> MAX size=1514,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_vlan_5_3_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000

${pcap_file},First 1500 frames -> MAC dst=00:00:00:00:00:01 and untagged,frame.number<=1500,eth.dst==00:00:00:00:00:01 && !(vlan),1500
${pcap_file},First 1500 frames -> MIN size=64,frame.number<=1500,MIN(frame.len)frame.len,64
${pcap_file},First 1500 frames -> MAX size=1514,frame.number<=1500,MAX(frame.len)frame.len,1514

${pcap_file},Second 1500 frames -> MAC dst=00:00:00:00:00:02 and untagged,frame.number>1500 and frame.number<=3000,eth.dst==00:00:00:00:00:02 && !(vlan),1500
${pcap_file},Second 1500 frames -> MIN size=60,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,60
${pcap_file},Second 1500 frames -> MAX size=1510,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1510
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 

function test_vlan_5_4_verifier(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 3000 frames,*,,3000

${pcap_file},First 1500 frames -> MAC dst=00:00:00:00:00:01 and untagged,frame.number<=1500,eth.dst==00:00:00:00:00:01 && !(vlan),1500
${pcap_file},First 1500 frames -> MIN size=64,frame.number<=1500,MIN(frame.len)frame.len,64
${pcap_file},First 1500 frames -> MAX size=1514,frame.number<=1500,MAX(frame.len)frame.len,1514

${pcap_file},Second 1500 frames -> MAC dst=00:00:00:00:00:02 and untagged,frame.number>1500 and frame.number<=3000,eth.dst==00:00:00:00:00:02 && !(vlan),1500
${pcap_file},Second 1500 frames -> MIN size=60,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,60
${pcap_file},Second 1500 frames -> MAX size=1510,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1510
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  SPECIAL RESULTS for tests VLAN 6,7 and 8
#-----------------------------------------------------------------------------------------------------------------------------------------

function priority_result(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 1500 frames,*,,1500
${pcap_file},Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:00:00:00:00:01,1500

${pcap_file},VLAN priority tagged (VID=0 PRI=0 DEI=0),frame.number<=1500,vlan.id==0 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},MIN size=64,frame.number<=1500,MIN(frame.len)frame.len,64
${pcap_file},MAX size=1514,frame.number<=1500,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
}

function vid100_result(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 1500 frames,*,,1500
${pcap_file},Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:00:00:00:00:01,1500

${pcap_file},VLAN tagged (VID=100 PRI=0 DEI=0),frame.number<=1500,vlan.id==100 && vlan.dei==0 && vlan.priority==0,1500
${pcap_file},MIN size=64,frame.number<=1500,MIN(frame.len)frame.len,64
${pcap_file},MAX size=1514,frame.number<=1500,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
}

function untag_result(){

csv_file=VERIFIER/Report/$config_type/${func}/${test_function}.csv
pcap_file=VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2.pcap

cat << EOF > $csv_file

PCAP file path,Description,Frames to analyze,Filter,Expected

${pcap_file},Total 1500 frames,*,,1500
${pcap_file},Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:00:00:00:00:01,1500

${pcap_file},Untagged frames,frame.number<=1500,!(vlan),1500
${pcap_file},MIN size=60,frame.number<=1500,MIN(frame.len)frame.len,60
${pcap_file},MAX size=1510,frame.number<=1500,MAX(frame.len)frame.len,1510
EOF

analyze_results_pcap $csv_file

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f "PCAP",Description,"Filter",Expected,Results,"PASS/FAIL" $file_csv > REPORTS/${func}/${test_function}.rpt 

cat REPORTS/${func}/${test_function}.rpt 

export_results
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.6 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_vlan_6_1_verifier(){

priority_result

}  


function test_vlan_6_2_verifier(){

vid100_result

}    

function test_vlan_6_3_verifier(){

untag_result

}

function test_vlan_6_4_verifier(){

untag_result

} 


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.7 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_vlan_7_1_verifier(){

priority_result
} 


function test_vlan_7_2_verifier(){

vid100_result

}    

function test_vlan_7_3_verifier(){

untag_result

}

function test_vlan_7_4_verifier(){

untag_result

} 

function test_vlan_7_5_verifier(){

priority_result
} 


function test_vlan_7_6_verifier(){

vid100_result

}    

function test_vlan_7_7_verifier(){

untag_result

}

function test_vlan_7_8_verifier(){

vid100_result

} 
#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test vlan.8 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_vlan_8_1_verifier(){

priority_result
} 


function test_vlan_8_2_verifier(){

vid100_result

}    

function test_vlan_8_3_verifier(){

untag_result

}

function test_vlan_8_4_verifier(){

untag_result

} 

function test_vlan_8_5_verifier(){

priority_result
} 


function test_vlan_8_6_verifier(){

vid100_result

}    

function test_vlan_8_7_verifier(){

untag_result

}

function test_vlan_8_8_verifier(){

vid100_result

}

function test_vlan_8_9_verifier(){

priority_result
} 


function test_vlan_8_10_verifier(){

vid100_result

}    

function test_vlan_8_11_verifier(){

untag_result

}

function test_vlan_8_12_verifier(){

untag_result

} 

function test_vlan_8_13_verifier(){

priority_result
} 


function test_vlan_8_14_verifier(){

vid100_result

}    

function test_vlan_8_15_verifier(){

untag_result

}

function test_vlan_8_16_verifier(){

untag_result

}
