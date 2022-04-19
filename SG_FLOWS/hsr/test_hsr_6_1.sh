#!/bin/bash

source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"

# Insert traffic flows here:

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" &
sudo python3 ${sw_dir}soce_generator.py --iface=$IF2 --filejson="SG_FLOWS/${func}/${test_function}_f2.json"


