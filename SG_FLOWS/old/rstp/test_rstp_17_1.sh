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

#!/bin/bash

#Set Port DUT1.TS1's Port Path Cost parameter to 0x00.
echo "Set Port Path Cost parameter to 0x00 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportcost br0 $port_0_name 0 1
sleep 3

echo "Set Port Path Cost parameter to 0x10 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportcost br0 $port_0_name 0 2000
sleep 3

echo "Set Port Path Cost parameter to 0x20 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportcost br0 $port_0_name 0 20000
sleep 3

echo "Set Port Path Cost parameter to 0x30 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportcost br0 $port_0_name 0 20000
sleep 3

echo "Set Port Path Cost parameter to 0x40 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportcost br0 $port_0_name 0 200000
sleep 3

echo "Set Port Path Cost parameter to 0x50 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportcost br0 $port_0_name 0 2000000
sleep 3

echo "Set Port Path Cost parameter to 0x50 for port 0 ($port_0_name)"
echo "================================================================="
echo ""
sshpass -p $username ssh -t -o StrictHostKeyChecking=no $password@$ip mstpctl settreeportcost br0 $port_0_name 0 12345
sleep 3
