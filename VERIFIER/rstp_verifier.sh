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
sw_dir=VERIFIER/SW_VERIFIER/
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}

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
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
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
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}

}

function test_rstp_4_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}     

function test_rstp_5_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}     

function test_rstp_6_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_7_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}    

function test_rstp_8_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}    


function test_rstp_9_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}   

function test_rstp_10_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}   

function test_rstp_11_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}

function test_rstp_11_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}   

function test_rstp_11_3_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}  


function test_rstp_12_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}

function test_rstp_12_2_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_13_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_14_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_15_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}

function test_rstp_16_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 


function test_rstp_17_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 


function test_rstp_18_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_19_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 


#####################

function test_rstp_1_1_verifier_tsnpcie(){

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
sw_dir=VERIFIER/SW_VERIFIER/
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}

}   

function test_rstp_2_1_verifier_tsnpcie(){

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
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}   

function test_rstp_3_1_verifier_tsnpcie(){

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
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}

}

function test_rstp_4_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}     

function test_rstp_5_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}     

function test_rstp_6_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_7_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}    

function test_rstp_8_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}    


function test_rstp_9_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}   

function test_rstp_10_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}   

function test_rstp_11_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}

function test_rstp_11_2_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}   

function test_rstp_11_3_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}  


function test_rstp_12_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}

function test_rstp_12_2_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_13_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_14_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_15_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
}

function test_rstp_16_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 


function test_rstp_17_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 


function test_rstp_18_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 

function test_rstp_19_1_verifier_tsnpcie(){

cat <<-EOF > dut_verifier.cmd
soce_cli

stp get_msti_status br0 0

EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
sw_dir=VERIFIER/SW_VERIFIER/
sudo python3 ${sw_dir}rstp_verifier.py ${test_function} $config_type ${func}
} 