#!/bin/bash

function hsr_stats_pre_config(){

cat <<-EOF > cmds/${test_function}.cmd
soce_cli
statistics get_rx_advanced_statistics $Redundant_A
statistics get_tx_advanced_statistics $Redundant_A
statistics get_rx_advanced_statistics $Redundant_B
statistics get_tx_advanced_statistics $Redundant_B
statistics get_rx_advanced_statistics $Interlink
statistics get_tx_advanced_statistics $Interlink
EOF

# statistics get_rx_advanced_statistics J6A
# statistics get_tx_advanced_statistics J6A
}


function test_hsr_5_1_pre_config(){

    hsr_stats_pre_config
}

function test_hsr_5_2_pre_config(){

    hsr_stats_pre_config
}

function test_hsr_5_3_pre_config(){

    hsr_stats_pre_config
}

function test_hsr_5_4_pre_config(){

    hsr_stats_pre_config
}
