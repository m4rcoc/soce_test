
#!usr/bin/python3
# -*- coding: utf-8 -*-

from scapy.all import *
import scapy.contrib.igmp
import sys
import os
import struct
import re
import random
import threading
from uuid import getnode

#ENCODING = "ISO-8859–1"
ENCODING = "utf-8"

#***************************************************************************************************************
# Global variables:
#***************************************************************************************************************

SEND_file = "Test_param"

#global IF1, IF2, IF3, IP_multicast, MAC_src, inter_multicast, inter_report

IF1="enxd0374502ac6e"
IF2="enxd0374502ac6e"
IF3="enxd0374502ac6e"
IP_multicast="225.1.1.4"
MAC_src="00:11:00:00:00:00"
inter_multicast=0.1
inter_report=2


def bytes2int(value_bytes):

    value_int = int.from_bytes(value_bytes,"big")
    
    return value_int
    
def getMAC_str():

    # to get physical address:
    original_mac_address = getnode()

    #convert raw format into hex format
    hex_mac_address = str(":".join(re.findall('..', '%012x' % original_mac_address)))
       
    return hex_mac_address

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# functions:

def read_Test_param():
    global IF1, IF2, IF3, IP_multicast, MAC_src, inter_multicast, inter_report
   
    param=list()
    with open(SEND_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  

    IF1 = param[0]
    IF2 = param[1]
    IF3 = param[2]
    IP_multicast = param[3]
    MAC_src = param[4]
    inter_multicast = float(param[5])
    inter_report = param[6]
       

def get_MAC_dst_multicast(ip_str):

    ip_octets = ip_str.split('.')
    mac="01:00:5E" # octet 0,1,2

    octet_3 = ':{:02x}'.format(int(ip_octets[1])&0x7F) # &7F : first bit = 0 
    octet_4 = ':{:02x}'.format(int(ip_octets[2]))
    octet_5 = ':{:02x}'.format(int(ip_octets[3]))

    mac=mac+octet_3+octet_4+octet_5
    
    return mac


def send_report_thread():
    os.system("sudo chmod +x send_report.sh")
    os.system("sudo ./send_report.sh "+IF2+" "+inter_report)


def function_sniff(packet):
    bytes_packet = bytes(packet)
    print(bytes_packet)
    

def sniff_multicast_IF3(interface , filter_sniff ):

    try:
        sniff(filter=filter_sniff,iface=interface, prn=function_sniff , count=0)
    except KeyboardInterrupt:
        exit(0)    
    return

#***************************************************************************************************************
# Main:
#***************************************************************************************************************

if __name__ == '__main__':

    #read_Test_param()

    IP_multicast = "225.1.2.3"
    interface="iface_aux"

    try:
        opts, args = getopt.getopt(sys.argv[1:], 'm:i:h', ['multicast=', 'interface=', 'help'])
    except getopt.GetoptError:
        usage()
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit(2)
        elif opt in ('-m', '--multicast'):
            IP_multicast=arg
        elif opt in ('-i', '--interface'):
            interface = arg
        else:
            usage()
            sys.exit(2)    


    MAC_src="00:12:34:56:78:9A"

    # sniff port multicast forwarding:
    print('\nSniffing muticast stream (filter ip=%s) on IF3 (%s) ...  \t(CTRL+C to stop)\n' % (IP_multicast, interface))

    sniff_multicast_IF3(interface,"ether src "+MAC_src)


  


    