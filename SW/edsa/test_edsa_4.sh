#!/bin/bash

# CAUTION:
# Input parameters: ./test_edsa_4.sh <DUT_password> <list_port_names>
array_i=( "$@" )

# cd edsa
filename="EDSA_param"
password=${array_i[0]}
list_ports=( ${array_i[1]} )


printf "\n"
for i in $(seq 0 3);
do

	port_name=${list_ports[$i]}

    echo "${port_name} > Sending out 10 frames with MAC_SRC=00:0$((i+1)):0$((i+1)):0$((i+1)):0$((i+1)):0$((i+1)) to the PORT $i of TS"

    sed -i $filename -e "1s/.*/Interface   =${port_name}/"
    sed -i $filename -e "2s/.*/MAC_dst    =00:0$((i+1)):0$((i+1)):0$((i+1)):0$((i+1)):0$((i+1))/"
    sed -i $filename -e "3s/.*/Position_N   =$i/"
    #cat $filename
    echo $password | sudo -S python3 edsa.py 4 $filename #> /dev/null 2>&1
    #python3 edsa.py 4 $filename

done