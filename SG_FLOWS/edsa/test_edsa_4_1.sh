#!/bin/bash



source platform.vars
source bash_functions/soce_bash_functions.sh
sw_dir="SW/soce_generator/"



# Insert traffic flows here:



mkdir -p REPORTS/${func}
rm -r REPORTS/${func}/${test_function}.out

cap_IF1=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap
cap_IF2=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap
cap_IF3=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap
cap_IF4=VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap

mkdir -p "${cap_IF1%/*}" && touch $cap_IF1
mkdir -p "${cap_IF2%/*}" && touch $cap_IF2
mkdir -p "${cap_IF3%/*}" && touch $cap_IF3
mkdir -p "${cap_IF4%/*}" && touch $cap_IF4


print_info "\tCapturing all HOST PC interfaces (IF1, IF2, IF3 and IF4) [parallel process]" | tee -a REPORTS/${func}/${test_function}.out

sudo timeout 10 tcpdump -i $IF1 ether src 00:01:01:01:01:01 or ether src 00:02:02:02:02:02 or ether src 00:03:03:03:03:03 or ether src 00:04:04:04:04:04 -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF1.pcap &
sudo timeout 10 tcpdump -i $IF2 ether src 00:01:01:01:01:01 or ether src 00:02:02:02:02:02 or ether src 00:03:03:03:03:03 or ether src 00:04:04:04:04:04 -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF2.pcap &
sudo timeout 10 tcpdump -i $IF3 ether src 00:01:01:01:01:01 or ether src 00:02:02:02:02:02 or ether src 00:03:03:03:03:03 or ether src 00:04:04:04:04:04 -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF3.pcap &
sudo timeout 10 tcpdump -i $IF4 ether src 00:01:01:01:01:01 or ether src 00:02:02:02:02:02 or ether src 00:03:03:03:03:03 or ether src 00:04:04:04:04:04 -w VERIFIER/Report/$config_type/${func}/$test_function/${test_function}_captured_IF4.pcap &


sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
cd edsa
chmod +x test_edsa_4.sh
./test_edsa_4.sh $password \"$port_0_name $port_1_name\"
"

