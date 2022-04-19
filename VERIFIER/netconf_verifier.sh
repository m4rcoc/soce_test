#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Netconf.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_netconf_1_1_verifier(){
mkdir -p REPORTS/${func}
print_info "\tConnecting to DUT Netconf Server ($ip)\n\tcmd=[netconf-console2 --port 830 --host $ip -u $username -p $password --db=running --get-config]\n\n" | tee REPORTS/${func}/${test_function}.out

netconf-console2 --port 830 --host $ip -u $username -p $password --db=running --get-config >> REPORTS/${func}/${test_function}.out
export_results

}  

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Netconf.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_netconf_2_1_verifier(){

export_results

}  

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Netconf.3 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_netconf_3_1_verifier(){

export_results

}

function test_netconf_3_1_verifier_tsn_pcie(){

export_results

}  


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Netconf.4 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_netconf_4_1_verifier(){

export_results

}  

function test_netconf_4_1_verifier_tsn_pcie(){

FILE=VERIFIER/Report/$config_type/${func}/${test_function}_tsn_pcie.csv

cat << EOF > $FILE

Type,Condition,Description,Frames to analyze,Filter,Expected

PCAP,1,Total 4500 frames,*,,4500
PCAP,2,Unicast Frames,*,eth.src==00:aa:aa:aa:aa:aa and eth.dst==00:bb:bb:bb:bb:bb,4500

PCAP,3,First 1500 frames -> VLAN tagged (VID=100 PRI=0 DEI=0),frame.number<=1500,vlan.id==100 && vlan.dei==0 && vlan.priority==0,1500
PCAP,4,First 1500 frames -> MIN size=68,frame.number<=1500,MIN(frame.len)frame.len,68
PCAP,5,First 1500 frames -> MAX size=1518,frame.number<=1500,MAX(frame.len)frame.len,1518

PCAP,6,Second 1500 frames -> VLAN tagged (VID=100 PRI=0 DEI=0),frame.number>1500 and frame.number<=3000,vlan.id==100 && vlan.dei==0 && vlan.priority==0,1500
PCAP,7,Second 1500 frames -> MIN size=64,frame.number>1500 and frame.number<=3000,MIN(frame.len)frame.len,64
PCAP,8,Second 1500 frames -> MAX size=1514,frame.number>1500 and frame.number<=3000,MAX(frame.len)frame.len,1514

PCAP,9,Last 1500 frames -> VLAN tagged (VID=200 PRI=0 DEI=0),frame.number>3000 and frame.number<=4500,vlan.id==200 && vlan.dei==0 && vlan.priority==0,1500
PCAP,10,Last 1500 frames -> MIN size=64,frame.number>3000 and frame.number<=4500,MIN(frame.len)frame.len,64
PCAP,11,Last 1500 frames -> MAX size=1514,frame.number>3000 and frame.number<=4500,MAX(frame.len)frame.len,1514
EOF

analyze_results_pcap VERIFIER/Report/$config_type/${func}/${test_function}_captured_IF2_tsn_pcie.pcap $FILE

mkdir -p REPORTS/${func}

mlr --icsv --opprint cut -f Condition,Description,"Frames to analyze",Expected,Results,"PASS/FAIL" $FILE > REPORTS/${func}/${test_function}_tsn_pcie.rpt 

cat REPORTS/${func}/${test_function}_tsn_pcie.rpt 

export_results

}  