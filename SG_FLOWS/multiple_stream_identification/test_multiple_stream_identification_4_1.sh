#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

mkdir -p REPORTS/${func}

python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f3.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f4.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f5.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f6.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f7.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f8.json"
sleep 1

rm -r REPORTS/${func}/${test_function}.out > /dev/null 2>&1

print_info "\tReading Stream Identification statistics:" | tee -a REPORTS/${func}/${test_function}.out
fast_soce_cli "
stream_identification get_per_port_per_stream_statistics $port_0_config 0
stream_identification get_per_port_per_stream_statistics $port_0_config 1
stream_identification get_per_port_per_stream_statistics $port_0_config 2
stream_identification get_per_port_per_stream_statistics $port_0_config 3
stream_identification get_per_port_per_stream_statistics $port_0_config 4
stream_identification get_per_port_per_stream_statistics $port_0_config 5
stream_identification get_per_port_per_stream_statistics $port_0_config 6
stream_identification get_per_port_per_stream_statistics $port_0_config 7
stream_identification get_per_port_statistics $port_0_config
" | tee -a REPORTS/${func}/${test_function}.out

# print_info "\tClear Table 0 (Null) and Table 2 (Active)" | tee -a REPORTS/${func}/${test_function}.out
# fast_soce_cli "
# stream_identification clear_stream_id_list SWITCH 0
# stream_identification clear_stream_id_list SWITCH 2
# stream_identification reset_port_statistics $port_0_config
# " | tee -a REPORTS/${func}/${test_function}.out


# python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"
# sleep 1
# python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"
# sleep 1
# python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f3.json"
# sleep 1
# python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f4.json"
# sleep 1
# python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f5.json"
# sleep 1
# python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f6.json"
# sleep 1
# python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f7.json"
# sleep 1
# python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f8.json"
# sleep 1

# print_info "\tReading Stream Identification statistics:" | tee -a REPORTS/${func}/${test_function}.out
# fast_soce_cli "
# stream_identification get_per_port_per_stream_statistics $port_0_config 0
# stream_identification get_per_port_per_stream_statistics $port_0_config 1
# stream_identification get_per_port_per_stream_statistics $port_0_config 2
# stream_identification get_per_port_per_stream_statistics $port_0_config 3
# stream_identification get_per_port_per_stream_statistics $port_0_config 4
# stream_identification get_per_port_per_stream_statistics $port_0_config 5
# stream_identification get_per_port_per_stream_statistics $port_0_config 6
# stream_identification get_per_port_per_stream_statistics $port_0_config 7
# stream_identification get_per_port_statistics $port_0_config
# " | tee -a REPORTS/${func}/${test_function}.out

print_info "\tClear specific streams of Table 0 (Null) and Table 2 (Active)" | tee -a REPORTS/${func}/${test_function}.out
fast_soce_cli "
stream_identification delete_null_stream_id SWITCH 0 00:DD:DD:DD:DD:DD 1
stream_identification delete_source_stream_id SWITCH 1 00:CC:CC:CC:CC:CC 2
stream_identification delete_active_stream_id SWITCH 2 00:DD:DD:DD:DD:DD 3 0
stream_identification delete_mask_and_match_stream_id SWITCH 3 00:DD:DD:DD:DD:DD 00:CC:CC:CC:CC:CC 81:00:00:04 aa:aa:aa:aa aa:aa:aa:aa aa:aa:aa:aa aa:aa:aa:aa
stream_identification reset_port_statistics $port_0_config
" | tee -a REPORTS/${func}/${test_function}.out

python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f3.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f4.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f5.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f6.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f7.json"
sleep 1
python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f8.json"
sleep 1

print_info "\tReading Stream Identification statistics:" | tee -a REPORTS/${func}/${test_function}.out
fast_soce_cli "
stream_identification get_per_port_per_stream_statistics $port_0_config 0
stream_identification get_per_port_per_stream_statistics $port_0_config 1
stream_identification get_per_port_per_stream_statistics $port_0_config 2
stream_identification get_per_port_per_stream_statistics $port_0_config 3
stream_identification get_per_port_per_stream_statistics $port_0_config 4
stream_identification get_per_port_per_stream_statistics $port_0_config 5
stream_identification get_per_port_per_stream_statistics $port_0_config 6
stream_identification get_per_port_per_stream_statistics $port_0_config 7
stream_identification get_per_port_statistics $port_0_config
" | tee -a REPORTS/${func}/${test_function}.out