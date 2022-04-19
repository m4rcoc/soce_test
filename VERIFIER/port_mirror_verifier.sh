#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Port mirror (TGES).1 – Unicast traffic to 10Mbps, 100Mbps and 1000Mbps
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirror_1_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

soce_cli

tges_port_mirroring set_mirror_input_ports SWITCH " "
tges_port_mirroring set_monitored_input_ports SWITCH " "
tges_port_mirroring disable_input_mirroring SWITCH
EOF
mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
}   


function test_port_mirror_2_1_verifier(){

cat <<-EOF > dut_verifier.cmd
soce_cli

tges_port_mirroring enable_output_mirroring SWITCH
tges_port_mirroring set_mirror_output_ports SWITCH " "
tges_port_mirroring set_monitored_output_ports SWITCH " "
EOF


mkdir -p REPORTS/${func}
sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_verifier.cmd | tee  REPORTS/${func}/${test_function}.out
mkdir -p VERIFIER/Report/$model/$config_type/${func}/$test_function/
cp REPORTS/${func}/${test_function}.out VERIFIER/Report/$model/$config_type/${func}/$test_function/${test_function}.out
}   

