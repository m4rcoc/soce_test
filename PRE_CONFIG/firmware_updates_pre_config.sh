#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Recovery & Firmware Update.1 – System updates
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_firmware_updates_1_1_pre_config(){

print_info "\tChecking if IP 192.168.2.64 is available"

sf_check_ping 192.168.2.126 1; r=$?
if [ $r == "1" ]; then 
    print_error "\tIP address 192.168.2.64 is busy."
    kill -s TERM $TOP_PID
    exit 0
fi

print_info "\tSending ${patch_name} to the DUT (/media/files_exchange)"
cd FILES_EXCHANGE/testing_fixes
sshpass -p $password scp -o StrictHostKeyChecking=no -r fix_testing_image_${model}_${version}.bin $username@$ip:/media/files_exchange > /dev/null 2>&1
cd ../..

}

#-----------------------------------------------------------------------------------------------------------------------------------------
#  [PRE-CONFIG] Test Recovery & Firmware Update.2 – System upgrades
#-----------------------------------------------------------------------------------------------------------------------------------------

function test_firmware_updates_2_1_pre_config(){

if ping -c 1 "192.168.2.64" &> /dev/null
then    
    print_error "\tIP address 192.168.2.64 is busy. "
    kill -s TERM $TOP_PID
    exit 0
fi


cd FILES_EXCHANGE/FIRMWARE
printf "\nSending image files (md5sums , boot_files and target_fs) to the DUT (/media/files_exchange)\n"
sshpass -p $password scp -o StrictHostKeyChecking=no -r "${md5sums}" $username@$ip:/media/files_exchange 
sshpass -p $password scp -o StrictHostKeyChecking=no -r "${boot_files}" $username@$ip:/media/files_exchange 
sshpass -p $password scp -o StrictHostKeyChecking=no -r "${target_fs}" $username@$ip:/media/files_exchange 
cd ../..

}



: '
if ping -c 1 "192.168.2.64" &> /dev/null
then    
    print_warning "\tIP address 192.168.2.64 is busy. "
else
    print_warning "\tIP address 192.168.2.64 is free. "
fi
'

: '
sf_check_ping 192.168.2.107 1; r=$?
if [ $r == "1" ]; then 
    print_warning "Busy(1)"
else
    print_warning "Free(0)"
fi
'


