#!/bin/bash


#-----------------------------------------------------------------------------------------------------------------------------------------
#  [VERIFIER] Test Firmware Updates.1 – 
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_firmware_updates_1_1_verifier(){

mkdir -p REPORTS/${func}
rm -r REPORTS/${func}/${test_function}.out

print_info "\tWaiting until DUT finishes the update"
sleep 20

while ! ping -c 1 -n -w 1 $ip &> /dev/null
do
    printf "%c" "."
done

sshpass -p $password scp -o StrictHostKeyChecking=no -r $username@$ip:/var/log/last_upgrade.log REPORTS/${func}/${test_function}.out  > /dev/null 2>&1
export_results

}  
