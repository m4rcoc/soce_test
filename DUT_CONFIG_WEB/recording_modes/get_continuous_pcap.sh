#!/bin/bash

username=$1
password=$2
ip=$3
output_file=$4

ssh-keygen -R $ip > /dev/null 2>&1
date_aux=$(date +"%Y_%m_%d")
sshpass -p $password scp -o StrictHostKeyChecking=no -r $username@$ip:/media/hdd1/downloads/*continuous* "${output_file}_${date_aux}.pcap"
