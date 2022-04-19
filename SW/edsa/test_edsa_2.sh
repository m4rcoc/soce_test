#!/bin/bash

# CAUTION:
# Input parameters: ./test_edsa_2.sh <DUT_password> <mgmt_port>
array_i=( "$@" )

# cd edsa
password=${array_i[0]}
MGT_PORT=${array_i[1]}

# Hardcoded to first block of ports
block=0

# cd edsa
filename="EDSA_tag_param"
sed -i $filename -e "1s/.*/Interface    =$MGT_PORT/"

for i in $(seq 0 3);
do
	port_name="port_${i}_config"
        echo "$MGT_PORT (MGT_PORT) > Sending out 10 EDSA_frames with MAC_SRC=00:0$((i+1)):0$((i+1)):0$((i+1)):0$((i+1)):0$((i+1)) to the port $i of TS"

        sed -i $filename -e "3s/.*/MAC_SRC    =00:0$((i+1)):0$((i+1)):0$((i+1)):0$((i+1)):0$((i+1))/"
	#printf "\nDEBUG: DST_port=$(($(($block*4))+$i))\n"
        sed -i $filename -e "4s/.*/DST_port   =$(($(($block*4))+$i))/"

        echo $password | sudo -S python3 edsa.py -t $filename > /dev/null 2>&1

done