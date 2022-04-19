#!/bin/bash

# Service failed during start-up
echo "Service failed during start-up"
echo "=============================="
systemctl --failed
echo ""
sleep 1

# Error messages during start-up
echo "Error messages"
echo "=============="
journalctl --no-pager -b -p err
echo ""
sleep 1

# Hostname
echo "Hostname"
echo "========"
hostname
echo ""
