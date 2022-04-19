#!/bin/bash

test_function=$1
func=$2
IF1=$3
IF2=$4
IF3=$5

sw_dir="SW/soce_generator/"

rm -f /usr/local/start
sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --filejson="SG_FLOWS/${func}/${test_function}_f1.json" --start