#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Basic traffic.1 – Unicast traffic to 10Mbps, 100Mbps and 1000Mbps
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_basic_traffic_1_1_verifier(){

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
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

current=$(pwd)
cd "${results_path}"
mkdir -p basic_traffic
cd $current
cp -r VERIFIER/Report/soce_cli/basic_traffic/* "${results_path}/basic_traffic"
}   

function test_basic_traffic_1_2_verifier(){

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
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

current=$(pwd)
cd "${results_path}"
mkdir -p basic_traffic
cd $current
cp -r VERIFIER/Report/soce_cli/basic_traffic/* "${results_path}/basic_traffic"
}  

function test_basic_traffic_1_3_verifier(){

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
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out

current=$(pwd)
cd "${results_path}"
mkdir -p basic_traffic
cd $current
cp -r VERIFIER/Report/soce_cli/basic_traffic/* "${results_path}/basic_traffic"
}  
