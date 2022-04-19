#!/bin/bash
#no modificar!!!!
test_function=$1
func=$2
config_type=$3
MAC_IF1=AA:AA:AA:AA:AA:AA
MAC_IF2=BB:BB:BB:BB:BB:BB
MAC_IF3=CC:CC:CC:CC:CC:CC
source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"
sleep 20
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
sudo timeout 120 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 120 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 120 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
#sudo timeout 120 tcpdump -i $IF4  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &
sleep 20



cat <<-EOF > dut_verifier.cmd
soce_cli
stp set_bridge_param br0 bridge_forward_delay 4
exit
sleep 10
soce_cli
stp set_bridge_param br0 bridge_forward_delay 1
exit
sleep 10
soce_cli
stp set_bridge_param br0 bridge_forward_delay 3
exit
sleep 10
soce_cli
stp set_bridge_param br0 bridge_forward_delay 31
exit
sleep 10
soce_cli
stp set_bridge_param br0 bridge_forward_delay 40
exit
sleep 10
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out





