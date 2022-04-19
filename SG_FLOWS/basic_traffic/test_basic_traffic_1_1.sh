#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:
#cmd="python3 ${sw_dir}soce_generator.py --iface=$IF1 --iface_read=$IF2 --filejson="SG_FLOWS/${func}/flow_1.json" --start --config_type=$config_type"
#xterm_cmd "${cmd}"
#sudo python3 -c 'import os,sys,fcntl; flags = fcntl.fcntl(sys.stdout, fcntl.F_GETFL);' 

print_info "Configuring interfaces to 10 Mbps... [IF1=${IF1} , IF2=${IF2} , IF3=${IF3} , IF4=${IF4}]"
config_speed_ifaces 10 $IF1 $IF2 $IF3 $IF4

sleep 0.1
sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" --sync &
sleep 0.1
sudo python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f2.json" --sync &
sleep 0.1
sudo python3 ${sw_dir}soce_generator.py --iface=$IF3 --filejson="SG_FLOWS/${func}/${test_function}_f3.json" --sync &
sleep 0.1
sudo python3 ${sw_dir}soce_generator.py --iface=$IF4 --filejson="SG_FLOWS/${func}/${test_function}_f4.json" 

