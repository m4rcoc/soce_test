#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

fast_soce_cli "
statistics reset_all_statistics ${IP_core_name}
"

python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" 

rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1
fast_soce_cli "
statistics get_rx_advanced_statistics ${Redundant_A}
statistics get_tx_advanced_statistics ${Redundant_B}
" -r
