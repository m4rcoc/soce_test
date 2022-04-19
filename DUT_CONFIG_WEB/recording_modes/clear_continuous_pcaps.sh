#!/bin/bash

username=$1
password=$2
ip=$3

ssh-keygen -R $ip > /dev/null 2>&1

sshpass -p $password ssh -o StrictHostKeyChecking=no $username@$ip "echo $password | sudo -S rm -r /media/hdd1/*continuous*; echo $password | sudo -S rm -r /media/hdd1/capture_id; echo $password | sudo -S rm -r /media/hdd1/downloads/*; echo $password | sudo -S systemctl restart network_recorder"

sleep 3
