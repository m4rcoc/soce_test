#!/bin/bash



source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"



# Insert traffic flows here:
sleep 30
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
sudo timeout 70 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 70 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 70 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sudo timeout 70 tcpdump -i $IF4  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &
sleep 5      

cat <<-EOF > dut_config.cmd
soce_cli
stp set_bridge_msti_param br0 0 priority 0xF
stp restart
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sleep 4

cat <<-EOF > dut_config.cmd
soce_cli
stp set_bridge_msti_param br0 0 priority 0xA
stp restart
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sleep 4

cat <<-EOF > dut_config.cmd
soce_cli
stp set_bridge_msti_param br0 0 priority 0x6
stp restart
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sleep 4

cat <<-EOF > dut_config.cmd
soce_cli
stp set_bridge_msti_param br0 0 priority 0x3
stp restart
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sleep 4

cat <<-EOF > dut_config.cmd
soce_cli
stp set_bridge_msti_param br0 0 priority 0x0
stp restart
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip <dut_config.cmd
sleep 4

