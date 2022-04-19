#!/bin/bash

test_function=$1
IF1=$2
IF2=$3

sw_dir="SW/soce_generator/"

sudo python3 ${sw_dir}soce_generator.py --iface=$IF1 --iface_read=$IF2 --filejson="${test_function}.json" --wait 1