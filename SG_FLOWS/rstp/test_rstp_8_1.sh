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
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/

sudo timeout 50 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 50 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 50 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sleep 10
sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/RSTP_app/RSTP_frame_format/MakeRootPortBigMsgTimesRST  $IF1
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/RSTP_app/RSTP_frame_format/MakeRootPortBigMsgTimesRST $MAC_IF1
python3 SW/RSTP_MSTP/RSTP_app/rstp.py -t  SW/RSTP_MSTP/RSTP_app/RSTP_frame_format/MakeRootPortBigMsgTimesRST &
sleep 10
sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/RSTP_app/RSTP_frame_format/RootAgreementRST   $IF2
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/RSTP_app/RSTP_frame_format/RootAgreementRST $MAC_IF2
python3 SW/RSTP_MSTP/RSTP_app/rstp.py -t  SW/RSTP_MSTP/RSTP_app/RSTP_frame_format/RootAgreementRST  
sleep 15
sudo touch SW/RSTP_MSTP/RSTP_app/salir

sleep 15

sudo rm SW/RSTP_MSTP/RSTP_app/salir