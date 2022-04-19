#!/bin/bash



source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"



# Insert traffic flows here:

mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
sudo timeout 150 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 150 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 150 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
#sudo timeout 150 tcpdump -i $IF4  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &
sleep 5      
echo $port_0_name
cat <<-EOF > dut_config.cmd
soce_cli
stp set_bridge_port_msti_config br0 $port_0_name 0 0x0 0x4E20
stp set_bridge_port_msti_config br0 $port_1_name 0 0x2 0x4E20
stp set_bridge_port_msti_config br0 $port_2_name 0 0x5 0x4E20
stp restart
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sleep 40

cat <<-EOF > dut_config.cmd
soce_cli
stp set_bridge_port_msti_config br0 $port_0_name 0 0x6 0x4E20
stp set_bridge_port_msti_config br0 $port_1_name 0 0x7 0x4E20
stp set_bridge_port_msti_config br0 $port_2_name 0 0x9 0x4E20
stp restart
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sleep 40

cat <<-EOF > dut_config.cmd
soce_cli
stp set_bridge_port_msti_config br0 $port_0_name 0 0xA 0x4E20
stp set_bridge_port_msti_config br0 $port_1_name 0 0xD 0x4E20
stp set_bridge_port_msti_config br0 $port_2_name 0 0xF 0x4E20
stp restart
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sleep 40

