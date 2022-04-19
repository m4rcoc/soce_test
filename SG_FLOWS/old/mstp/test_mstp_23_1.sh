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
sleep 20
sudo timeout 60 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 60 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 60 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sudo timeout 60 tcpdump -i $IF4  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &
sleep 5
sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" --start&
cat <<-EOF > dut_config.cmd
soce_cli
stp set_port_state $port_0_name 1 forwarding
stp set_port_state $port_0_name 2 forwarding
stp set_port_state $port_0_name 0 forwarding
stp set_port_state$port_1_name 1 forwarding
stp set_port_state$port_1_name 2 forwarding
stp set_port_state$port_1_name 0 forwarding
stp set_port_state $port_2_name 1 forwarding
stp set_port_state $port_2_name 2 forwarding
stp set_port_state $port_2_name 0 forwarding
stp set_port_state $port_3_config 1 forwarding
stp set_port_state $port_3_config 2 forwarding
stp set_port_state $port_3_config 0 forwarding
stp get_port_state $port_0_name 0
stp get_port_state $port_0_name 1
stp get_port_state $port_0_name 2
stp get_port_state$port_1_name 0
stp get_port_state$port_1_name 1
stp get_port_state$port_1_name 2
stp get_port_state $port_2_name 0
stp get_port_state $port_2_name 1
stp get_port_state $port_2_name 2
stp get_port_state $port_3_config 0
stp get_port_state $port_3_config 1
stp get_port_state $port_3_config 2

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sudo python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f2.json" --start&
sudo python3 ${sw_dir}soce_generator.py --iface=$IF3 --filejson="SG_FLOWS/${func}/${test_function}_f3.json" --start&
sudo python3 ${sw_dir}soce_generator.py --iface=$IF4 --filejson="SG_FLOWS/${func}/${test_function}_f4.json" --start 

sudo python3 SW/RSTP_MSTP/change_IF.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraMakeRootPortVlan2 $IF1
sudo python3 SW/RSTP_MSTP/change_macsrc.py SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraMakeRootPortVlan2 $MAC_IF1
python3 SW/RSTP_MSTP/MSTP_app/mstp_v1.py -t  SW/RSTP_MSTP/MSTP_app/MSTP_frame_format/MST.IntraMakeRootPortVlan2   
cat <<-EOF > dut_config.cmd
soce_cli

stp get_port_state $port_0_name 0
stp get_port_state $port_0_name 1
stp get_port_state $port_0_name 2
stp get_port_state$port_1_name 0
stp get_port_state$port_1_name 1
stp get_port_state$port_1_name 2
stp get_port_state $port_2_name 0
stp get_port_state $port_2_name 1
stp get_port_state $port_2_name 2
stp get_port_state $port_3_config 0
stp get_port_state $port_3_config 1
stp get_port_state $port_3_config 2

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
