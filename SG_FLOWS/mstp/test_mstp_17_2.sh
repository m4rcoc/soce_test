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
sudo timeout 50 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 50 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 50 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sudo timeout 50 tcpdump -i $IF4  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &
sleep 10

sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraCISTIntPathCost_FFFFFFFE $IF1
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraCISTIntPathCost_FFFFFFFE $MAC_IF1
python3 SW/RSTP_MSTP/MSTP_app/mstp_v1.py -t  SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraCISTIntPathCost_FFFFFFFE &  

sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.OtherRegionThanDUT $IF2
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.OtherRegionThanDUT $MAC_IF2
python3 SW/RSTP_MSTP/MSTP_app/mstp_v1.py -t  SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.OtherRegionThanDUT  &  

sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraCISTIntPathCost_FFFFFFFF $IF3
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraCISTIntPathCost_FFFFFFFF $MAC_IF3
python3 SW/RSTP_MSTP/MSTP_app/mstp_v1.py -t  SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraCISTIntPathCost_FFFFFFFF &   

sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.WorseRootIDThanDUT $IF4
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.WorseRootIDThanDUT $MAC_IF4
python3 SW/RSTP_MSTP/MSTP_app/mstp_v1.py -t  SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.WorseRootIDThanDUT  


