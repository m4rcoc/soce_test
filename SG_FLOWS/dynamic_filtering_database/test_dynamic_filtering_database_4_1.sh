#!/bin/bash



source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"



# Insert traffic flows here:
ssh-keygen -R 192.168.2.146
sshpass -p soce ssh -t -o StrictHostKeyChecking=no soce@192.168.2.146 <<EOF
 cd c:\\Users\\soce\\Documents\\ixia 
 python automated_ixia.py  -t $test_function -m $model -v $version
EOF
touch /usr/local/start
