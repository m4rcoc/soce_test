#!/bin/bash
#no modificar!!!!
test_function=$1
func=$2
config_type=$3

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/

sudo timeout 30 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 30 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 30 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sleep 5
echo "Set the Bridge Max Age to 6, and Bridge Forward Delay to 4"
echo "=========================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setmaxage br0 6
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setfdelay br0 4
sleep 3

echo "Set the Bridge Forward Delay to 15"
echo "=================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setfdelay br0 15
sleep 3

echo "Set the Bridge Forward Delay to 30"
echo "=================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setfdelay br0 30
sleep 3

echo "Set the Bridge Forward Delay to 12"
echo "=================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setfdelay br0 12
sleep 3

echo "Set the Bridge Forward Delay to 23"
echo "=================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setfdelay br0 23
sleep 3
