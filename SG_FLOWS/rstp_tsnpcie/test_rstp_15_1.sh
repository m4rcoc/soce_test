#!/bin/bash



source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"



# Insert traffic flows here:
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/

sudo timeout 30 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 30 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 30 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sleep 5

echo "Set the Bridge Max Age to 6"
echo "==========================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setmaxage br0 6
sleep 3

echo "Set the Bridge Max Age to 20"
echo "============================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setmaxage br0 20
sleep 3

echo "Set the Bridge Max Age to 28"
echo "============================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setmaxage br0 28
sleep 3

echo "Set the Bridge Max Age to 40, and Bridge Forward Delay to 21"
echo "============================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setfdelay br0 21
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setmaxage br0 40
sleep 3

echo "Set the Bridge Max Age to 16, and Bridge Forward Delay to 9"
echo "==========================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setmaxage br0 16
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setfdelay br0 9
sleep 3

echo "Set the Bridge Max Age to 32, and Bridge Forward Delay to 17"
echo "============================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setfdelay br0 17
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl setmaxage br0 32
sleep 3


