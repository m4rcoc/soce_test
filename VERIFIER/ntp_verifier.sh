#!/bin/bash


function get_ntp_status(){

sshpass -p $password ssh -t -o StrictHostKeyChecking=no $username@$ip "
soce_cli <<-EOF
ntp service_status
ntp sync_status
ntp peers
time_date get
EOF
" | tee -a REPORTS/${func}/${test_function}.out
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test NTP.1 – Synchronization to external servers
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_ntp_1_1_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

export_results
}   

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test NTP.2 – NTP broadcast
#-----------------------------------------------------------------------------------------------------------------------------------------


function test_ntp_2_1_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

fast_soce_cli "
ntp set_broadcast_conf enabled 192.168.2.255 8 none
ntp restart
"

printf "\n"
print_info "\tCapturing through [${iface_host}] NTP broadcast frames..."
timeout 50 tcpdump -i $iface_host -c 4 src host $ip and dst host 192.168.2.255 and dst port 123 -w REPORTS/${func}/${test_function}.pcap

export_results
}

function test_ntp_2_2_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

fast_soce_cli "
ntp set_broadcast_conf enabled 192.168.4.255 8 none
ntp restart
"

printf "\n"
print_info "\tCapturing through [${IF1}] NTP broadcast frames..."
timeout 50 tcpdump -i $IF1 -c 4 src host 192.168.4.64 and dst host 192.168.4.255 and dst port 123 -w REPORTS/${func}/${test_function}.pcap

export_results
}

function test_ntp_2_3_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

fast_soce_cli "
ntp set_broadcast_conf enabled 192.168.4.255 16 none
ntp restart
"

printf "\n"
print_info "\tCapturing through [${IF1}] NTP broadcast frames..."
timeout 80 tcpdump -i $IF1 -c 4 src host 192.168.4.64 and dst host 192.168.4.255 and dst port 123 -w REPORTS/${func}/${test_function}.pcap

export_results
}

function test_ntp_2_4_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

fast_soce_cli "
ntp set_broadcast_conf enabled 192.168.4.255 32 none
ntp restart
"

printf "\n"
print_info "\tCapturing through [${IF1}] NTP broadcast frames..."
timeout 160 tcpdump -i $IF1 -c 4 src host 192.168.4.64 and dst host 192.168.4.255 and dst port 123 -w REPORTS/${func}/${test_function}.pcap

export_results
}

function test_ntp_2_5_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

fast_soce_cli "
ntp set_broadcast_conf enabled 192.168.4.255 64 none
ntp restart
"

printf "\n"
print_info "\tCapturing through [${IF1}] NTP broadcast frames..."
timeout 320 tcpdump -i $IF1 -c 4 src host 192.168.4.64 and dst host 192.168.4.255 and dst port 123 -w REPORTS/${func}/${test_function}.pcap

export_results
}

function test_ntp_2_6_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

fast_soce_cli "
ntp set_broadcast_conf enabled 192.168.4.255 128 none
ntp restart
"

printf "\n"
print_info "\tCapturing through [${IF1}] NTP broadcast frames..."
timeout 640 tcpdump -i $IF1 -c 4 src host 192.168.4.64 and dst host 192.168.4.255 and dst port 123 -w REPORTS/${func}/${test_function}.pcap

export_results
}

function test_ntp_2_7_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

fast_soce_cli "
ntp set_broadcast_conf enabled 192.168.4.255 256 none
ntp restart
"

printf "\n"
print_info "\tCapturing through [${IF1}] NTP broadcast frames..."
timeout 1280 tcpdump -i $IF1 -c 4 src host 192.168.4.64 and dst host 192.168.4.255 and dst port 123 -w REPORTS/${func}/${test_function}.pcap

export_results
}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test NTP.3 – NTP multicast
#-----------------------------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test NTP.4 – NTP manycast
#-----------------------------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test NTP.5 – NTP servers with authentication (Symmetric/Private Key)
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_ntp_5_1_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

export_results
}  


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test NTP.6 – NTP leap second handling
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_ntp_6_1_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

export_results
}  

function test_ntp_6_2_verifier(){

mkdir -p REPORTS/${func}
print_info "\tNTP STATUS after 1 second:" | tee REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

sleep 20
print_info "\tNTP STATUS after 20 second:" | tee -a REPORTS/${func}/${test_function}.out
get_ntp_status | tee -a REPORTS/${func}/${test_function}.out

export_results
}  
