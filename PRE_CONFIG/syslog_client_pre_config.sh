#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Syslog Client.1 – Syslog client control
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_syslog_client_1_1_pre_config(){

# SYSLOS SERVER (VM test_lubuntu_rugged):
local user_server="soc-e"
local password_server="soc-e"
local ip_server="192.168.2.39"

print_info "\tSending FILES_EXCHANGE/CA/$CA_certificate to the DUT(/media/files_exchange)"
cd FILES_EXCHANGE/CA
sshpass -p $password scp -o StrictHostKeyChecking=no -r "${CA_certificate}" $username@$ip:/media/files_exchange > /dev/null 2>&1
cd ../..

#exec xterm -title "SYSLOG_SERVER" -hold  -e 'sshpass -p soc-e ssh -t -o StrictHostKeyChecking=no soc-e@$192.168.2.39 < "echo soc-e | sudo -S systemctl stop syslog-ng; echo soc-e | sudo -S /usr/sbin/syslog-ng -Fdev" ; bash' &

# print_info "\tLaunching Syslog Server service on VM test_lubuntu_rugged (192.168.2.39) [Saving log file remotely]"
# xterm -title "Syslog Server" -hold -e "sshpass -p $password_server ssh -t -o StrictHostKeyChecking=no  $user_server@$ip_server \"
# echo $password_server | sudo -S systemctl stop syslog-ng
# echo $password_server | sudo -S /usr/sbin/syslog-ng -Fdev 2>&1 | tee /var/log/server.log
# \"
# " &
# pid_xterm_server=$!

# print_info "\tSaving pid_xterm_server on /usr/local/etc/pid_xterm_server"
# echo $pid_xterm_server > /usr/local/etc/pid_xterm_server

sshpass -p $password_server ssh -t -o StrictHostKeyChecking=no  $user_server@$ip_server "
echo $password_server | sudo -S systemctl stop syslog-ng
echo $password_server | sudo -S rm -f /home/soc-e/server.log
echo $password_server | sudo -S /usr/sbin/syslog-ng -Fdev > /home/soc-e/server.log &
pid_server=$!
echo $pid_server
echo $password_server | sudo -S echo $pid_server > /tmp/pid_server
cat /tmp/pid_server
" &

# echo $password_server | sudo -S /usr/sbin/syslog-ng -Fdev 2>&1 | tee /var/log/server.log
}
