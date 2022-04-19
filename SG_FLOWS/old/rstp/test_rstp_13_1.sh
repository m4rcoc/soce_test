#!/bin/bash
#no modificar!!!!
test_function=$1
func=$2
config_type=$3

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/

sudo timeout 60 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 60 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 60 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sleep 5

echo "Set the Bridge Identifier Priority parameter to 0x0000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 0
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x1000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 1
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x2000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 2
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x3000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 3
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x4000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 4
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x5000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 5
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x6000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 6
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x7000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 7
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x8000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 8
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0x9000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 9
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0xA000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 10
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0xB000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 11
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0xC000"
echo "======================================================"
echo ""
mstpctl settreeprio br0 0 12
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0xD000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 13
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0xE000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 14
sleep 3

echo "Set the Bridge Identifier Priority parameter to 0xF000"
echo "======================================================"
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip  mstpctl settreeprio br0 0 15