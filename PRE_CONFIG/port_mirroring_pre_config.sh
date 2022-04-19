#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Port mirroring.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirroring_1_1_pre_config(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1
mac_address_table set_static_entry SWITCH AA:AA:AA:AA:AA:AA 1 J1A
mac_address_table set_static_entry SWITCH BB:BB:BB:BB:BB:BB 1 J1B

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Port mirroring.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirroring_1_2_pre_config(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1
mac_address_table set_static_entry SWITCH AA:AA:AA:AA:AA:AA 1 J1A
mac_address_table set_static_entry SWITCH BB:BB:BB:BB:BB:BB 1 J1B
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Port mirroring.1 – restore
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirroring_1_1_pre_config_restore(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Port mirroring.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirroring_1_2_pre_config_restore(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Port mirroring.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirroring_2_1_pre_config(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1
mac_address_table delete_static_entry SWITCH CC:CC:CC:CC:CC:CC 1
mac_address_table delete_static_entry SWITCH DD:DD:DD:DD:DD:DD 1
mac_address_table set_static_entry SWITCH AA:AA:AA:AA:AA:AA 1 J1A
mac_address_table set_static_entry SWITCH BB:BB:BB:BB:BB:BB 1 J1B
mac_address_table set_static_entry SWITCH CC:CC:CC:CC:CC:CC 1 J1C
mac_address_table set_static_entry SWITCH DD:DD:DD:DD:DD:DD 1 J1D

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}


function test_port_mirroring_3_1_pre_config(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1
mac_address_table delete_static_entry SWITCH CC:CC:CC:CC:CC:CC 1
mac_address_table delete_static_entry SWITCH DD:DD:DD:DD:DD:DD 1
mac_address_table set_static_entry SWITCH AA:AA:AA:AA:AA:AA 1 J1A
mac_address_table set_static_entry SWITCH BB:BB:BB:BB:BB:BB 1 J1B
mac_address_table set_static_entry SWITCH CC:CC:CC:CC:CC:CC 1 J1C
mac_address_table set_static_entry SWITCH DD:DD:DD:DD:DD:DD 1 J1D

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}
#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Port mirroring.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirroring_2_2_pre_config(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1
mac_address_table delete_static_entry SWITCH CC:CC:CC:CC:CC:CC 1
mac_address_table delete_static_entry SWITCH DD:DD:DD:DD:DD:DD 1
mac_address_table set_static_entry SWITCH AA:AA:AA:AA:AA:AA 1 J1A
mac_address_table set_static_entry SWITCH BB:BB:BB:BB:BB:BB 1 J1B
mac_address_table set_static_entry SWITCH CC:CC:CC:CC:CC:CC 1 J1C
mac_address_table set_static_entry SWITCH DD:DD:DD:DD:DD:DD 1 J1D
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}


function test_port_mirroring_4_1_pre_config(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1
mac_address_table delete_static_entry SWITCH CC:CC:CC:CC:CC:CC 1
mac_address_table delete_static_entry SWITCH DD:DD:DD:DD:DD:DD 1

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}
#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Port mirroring.2 – restore
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirroring_2_1_pre_config_restore(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1
mac_address_table delete_static_entry SWITCH CC:CC:CC:CC:CC:CC 1
mac_address_table delete_static_entry SWITCH DD:DD:DD:DD:DD:DD 1


EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Port mirroring.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_port_mirroring_2_2_pre_config_restore(){

cat <<-EOF > dut_pre_config.cmd
soce_cli
tges_port_mirroring set_monitored_output_ports SWITCH ""
tges_port_mirroring set_mirror_output_ports SWITCH ""
tges_port_mirroring set_monitored_input_ports SWITCH ""
tges_port_mirroring set_mirror_input_ports SWITCH ""
tges_port_mirroring disable_input_mirroring SWITCH
tges_port_mirroring disable_output_mirroring SWITCH
mac_address_table delete_static_entry SWITCH AA:AA:AA:AA:AA:AA 1
mac_address_table delete_static_entry SWITCH BB:BB:BB:BB:BB:BB 1
mac_address_table delete_static_entry SWITCH CC:CC:CC:CC:CC:CC 1
mac_address_table delete_static_entry SWITCH DD:DD:DD:DD:DD:DD 1

EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}