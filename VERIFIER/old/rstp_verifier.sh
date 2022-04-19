#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Basic traffic.1 – Unicast traffic to 10Mbps, 100Mbps and 1000Mbps
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_rstp_1_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_3_config
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
mac_address_table enable_ageing SWITCH 

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
}   

function test_rstp_2_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_3_config
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
mac_address_table enable_ageing SWITCH 

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
}   

function test_rstp_3_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

statistics get_rx_basic_statistics $port_0_config
statistics get_tx_basic_statistics $port_0_config
statistics get_rx_basic_statistics $port_1_config
statistics get_tx_basic_statistics $port_1_config
statistics get_rx_basic_statistics $port_2_config
statistics get_tx_basic_statistics $port_2_config
statistics get_rx_basic_statistics $port_3_config
statistics get_tx_basic_statistics $port_3_config
mac_address_table get_port_entries $port_0_config
mac_address_table get_port_entries $port_1_config
mac_address_table get_port_entries $port_2_config
mac_address_table get_port_entries $port_3_config
mac_address_table enable_ageing SWITCH 

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out

}   