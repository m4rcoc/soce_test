#!/bin/bash

fileconf="copy_platform.vars"

if [ -e $fileconf ]
then
        source $fileconf
else
        echo "File $fileconf not found"
        exit 0
fi

# Service port IP
echo "Service port IP"
echo "==============="
ip addr show $SERVICE_PORT
echo ""
sleep 1

# LAN connectivity
echo "LAN connectivity"
echo "==============="
ping -c 8 192.168.2.1
echo ""
sleep 1

# WAN connectivity
echo "WAN connectivity"
echo "==============="
ping -c 8 8.8.8.8
echo ""
sleep 1

# DNS resolution
echo "DNS resolution"
echo "=============="
ping -c 8 soc-e.com
echo ""
sleep 1

# Switching ports IP
echo "Switching ports IP"
echo "=================="
ip addr show $MGT_PORT
echo ""
sleep 1

# Switching ports connectivity
echo "Switching ports connectivity"
echo "============================"
#spt_config_reg -f SWITCH:mux_ctrl -w 0
ping -c 8 192.168.4.64
echo ""
