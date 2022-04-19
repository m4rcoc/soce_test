#!/bin/bash
#no modificar!!!!
test_function=$1
func=$2
config_type=$3

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/

sudo timeout 90 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 90 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 90 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sleep 5

#!/bin/bash

#Set Port DUT1.TS1's Port Identifier Priority parameter to 0x00.
echo "Set Port Identifier Priority parameter to 0x00 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 0
sleep 3

echo "Set Port Identifier Priority parameter to 0x10 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 1
sleep 3

echo "Set Port Identifier Priority parameter to 0x20 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 2
sleep 3

echo "Set Port Identifier Priority parameter to 0x30 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 3
sleep 3

echo "Set Port Identifier Priority parameter to 0x40 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 4
sleep 3

echo "Set Port Identifier Priority parameter to 0x50 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 5
sleep 3

echo "Set Port Identifier Priority parameter to 0x60 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 6
sleep 3

echo "Set Port Identifier Priority parameter to 0x70 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 7
sleep 3

echo "Set Port Identifier Priority parameter to 0x80 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 8
sleep 3

echo "Set Port Identifier Priority parameter to 0x90 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 9
sleep 3

echo "Set Port Identifier Priority parameter to 0xA0 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 10
sleep 3

echo "Set Port Identifier Priority parameter to 0xB0 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 11
sleep 3

echo "Set Port Identifier Priority parameter to 0xC0 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 12
sleep 3

echo "Set Port Identifier Priority parameter to 0xD0 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 13
sleep 3

echo "Set Port Identifier Priority parameter to 0xE0 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 14
sleep 3

echo "Set Port Identifier Priority parameter to 0xF0 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportprio br0 $port_0_name 0 15
sleep 3