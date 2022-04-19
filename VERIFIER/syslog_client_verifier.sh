#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Syslog Client.1 – Syslog client control
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_syslog_client_1_1_verifier(){

print_info "\t1. Attempting to connect ssh with incorrect password: TEST_1"
sshpass -p TEST_1 ssh -t -o StrictHostKeyChecking=no $username@$ip

print_info "\t2. Attempting to connect ssh with incorrect password: TEST_2"
sshpass -p TEST_2 ssh -t -o StrictHostKeyChecking=no $username@$ip


# SYSLOS SERVER (VM test_lubuntu_rugged):
local user_server="soc-e"
local password_server="soc-e"
local ip_server="192.168.2.39"

# print_info "\tKilling xterm syslog server (pid=$(echo /usr/local/etc/pid_xterm_server))"
# pid_to_kill=$(cat /usr/local/etc/pid_xterm_server)
# kill -9 $pid_to_kill

sshpass -p $password_server ssh -t -o StrictHostKeyChecking=no  $user_server@$ip_server "
echo $password_server | sudo -S cat /tmp/pid_server > pid_to_kill
echo $password_server | sudo -S kill -9 $pid_to_kill
" &

print_info "\tImport log file from Syslog Server [Saving on REPORTS/$func/]"
mkdir -p REPORTS/$func
sshpass -p $password_server scp -o StrictHostKeyChecking=no -r $user_server@$ip_server:/home/soc-e/server.log REPORTS/$func/

} 