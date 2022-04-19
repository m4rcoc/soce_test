#!/bin/bash
#no modificar!!!!
test_function=$1
func=$2
config_type=$3
MAC_IF1=AA:AA:AA:AA:AA:AA
MAC_IF2=BB:BB:BB:BB:BB:BB
MAC_IF3=CC:CC:CC:CC:CC:CC
MAC_IF4=DD:DD:DD:DD:DD:DD
source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"
sleep 20
mkdir VERIFIER/Report/$model/$config_type/${func}/$test_function/
sudo timeout 40 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 40 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 40 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sleep 5
sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.MakeRootPortBadProtoVerID2 $IF1
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.MakeRootPortBadProtoVerID2 $MAC_IF1
python3 SW/RSTP_MSTP/MSTP_app/mstp_v1.py -t  SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.MakeRootPortBadProtoVerID2 &

sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.OtherRegionThanDUT $IF2
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.OtherRegionThanDUT $MAC_IF2
python3 SW/RSTP_MSTP/MSTP_app/mstp_v1.py -t  SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.OtherRegionThanDUT