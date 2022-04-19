#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Basic traffic.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_basic_traffic_1_1_pre_config(){

cat <<-EOF > dut_pre_config.cmd
echo ${password} | sudo -S ethtool -s ${port_0_config} speed 10 duplex full autoneg on
echo ${password} | sudo -S ethtool -s ${port_1_config} speed 10 duplex full autoneg on
echo ${password} | sudo -S ethtool -s ${port_2_config} speed 10 duplex full autoneg on
echo ${password} | sudo -S ethtool -s ${port_3_config} speed 10 duplex full autoneg on
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Basic traffic.2 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_basic_traffic_1_2_pre_config(){

cat <<-EOF > dut_pre_config.cmd
echo ${password} | sudo -S ethtool -s ${port_0_config} speed 100 duplex full autoneg on
echo ${password} | sudo -S ethtool -s ${port_1_config} speed 100 duplex full autoneg on
echo ${password} | sudo -S ethtool -s ${port_2_config} speed 100 duplex full autoneg on
echo ${password} | sudo -S ethtool -s ${port_3_config} speed 100 duplex full autoneg on
EOF

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip < dut_pre_config.cmd
}
