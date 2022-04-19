#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Basic traffic.1 – Unicast traffic to 10Mbps, 100Mbps and 1000Mbps
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_mstp_1_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_3_config
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
stp get_port_state $port_0_config 1
stp get_port_state $port_0_config 2
stp get_port_state $port_2_config 1
stp get_port_state $port_2_config 2
mac_address_table enable_ageing SWITCH 
stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
}   

function test_mstp_1_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_3_config
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
stp get_port_state $port_0_config 1
stp get_port_state $port_0_config 2
stp get_port_state $port_2_config 1
stp get_port_state $port_2_config 2
mac_address_table enable_ageing SWITCH 
stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
}   

function test_mstp_1_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_3_config
stp get_port_state $port_0_config 1
stp get_port_state $port_0_config 2
stp get_port_state $port_2_config 1
stp get_port_state $port_2_config 2
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
mac_address_table enable_ageing SWITCH 
stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}   

function test_mstp_1_4_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_3_config
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
stp get_port_state $port_0_config 1
stp get_port_state $port_0_config 2
stp get_port_state $port_2_config 1
stp get_port_state $port_2_config 2
mac_address_table enable_ageing SWITCH 
stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}

function test_mstp_1_5_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_3_config
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
stp get_port_state $port_0_config 1
stp get_port_state $port_0_config 2
stp get_port_state $port_2_config 1
stp get_port_state $port_2_config 2
mac_address_table enable_ageing SWITCH 
stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}

function test_mstp_1_6_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_3_config
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
stp get_port_state $port_0_config 1
stp get_port_state $port_0_config 2
stp get_port_state $port_2_config 1
stp get_port_state $port_2_config 2
mac_address_table enable_ageing SWITCH 
stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}


function test_mstp_2_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_2_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_2_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_2_4_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_3_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_3_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_3_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_4_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_4_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_4_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_5_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_5_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_5_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_6_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_6_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_6_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_6_4_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_7_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_7_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_7_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_7_4_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}

function test_mstp_8_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_8_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_8_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_8_4_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}
function test_mstp_8_5_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}
function test_mstp_8_6_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}

function test_mstp_9_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_9_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_9_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_10_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_10_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_10_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}
function test_mstp_10_4_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_11_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_11_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_11_3_verifier(){
sudo timeout 60 tcpdump -i $IF1  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 60 tcpdump -i $IF2  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 60 tcpdump -i $IF3  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sudo timeout 60 tcpdump -i $IF4  -w VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &
sleep 10
cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
stp set_bridge_param br0 bridge_max_age 3
stp get_bridge_param br0 bridge_max_age
stp restart
exit
sleep 10
soce_cli
stp set_bridge_param br0 bridge_max_age 41
stp get_bridge_param br0 bridge_max_age
stp restart
exit
sleep 10
soce_cli
stp set_bridge_param br0 bridge_max_age 45
stp get_bridge_param br0 bridge_max_age
stp restart
exit
sleep 10
soce_cli
stp set_bridge_param br0 bridge_max_age 20
stp get_bridge_param br0 bridge_max_age
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
}

function test_mstp_12_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_12_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_12_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_13_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_13_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_13_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_13_4_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_14_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_15_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_15_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_16_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_16_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_17_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_17_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_17_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}


function test_mstp_18_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_18_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_18_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_19_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_19_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_19_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_20_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_20_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_21_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_22_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_22_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}

function test_mstp_23_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp delete_bridge_msti br0 1
stp delete_bridge_msti br0 2
stp set_bridge_param br0 bridge_vers none
vlan reset SWITCH
mac_address_table delete_all_dynamic_entries SWITCH
EOF
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

}