
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


def sniff_multicast_IF3(interface , filter_sniff ):
    sniff(filter=filter_sniff,iface=interface, prn=lambda p: p.show() , count=0)

    return

def usage():

    print("\n\tUsage: python3 multicast_generator.py -m <ip_multicast> -r <rate_tx> -i <interface>\n")

    return

#***************************************************************************************************************
# Main:
#***************************************************************************************************************

if __name__ == '__main__':

    IP_multicast = "225.1.2.3"
    rate=0.1
    interface="iface_aux"

    try:
        opts, args = getopt.getopt(sys.argv[1:], 'm:r:i:h', ['version=', 'type=', 'multicast=','rate=', 'interface=', 'help'])
    except getopt.GetoptError:
        usage()
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit(2)
        elif opt in ('-m', '--multicast'):
            IP_multicast=arg
        elif opt in ('-r', '--rate'):
            rate = float(arg)
        elif opt in ('-i', '--interface'):
            interface = arg
        else:
            usage()
            sys.exit(2)

    #Main thread: sending multicast stream
    
    MAC_src="00:12:34:56:78:9A"
    MAC_dst_multicast = get_MAC_dst_multicast(IP_multicast)

    print("Sending Multicast("+IP_multicast+") packets to "+MAC_dst_multicast+" through IF1 ("+interface+")  \t(CTRL+C to stop)")
    
    #sendp(p, loop=1, inter=0, verbose = False,iface=interface) 

    try:
        while True:
            data="Hello "+''.ljust(random.randint(64, 1518)-18-12-20,'x')+" World"
            p = Ether(src=MAC_src,dst=MAC_dst_multicast, type=0x0800)/IP(dst=IP_multicast,len=20)/Raw(data)     
            #FCS=0x9fe83f6f

            #p /= FCS.to_bytes(4,'big')   
            sendp(p, count=1, verbose = False,iface=interface)
            #print(".", end=' ') 
    except KeyboardInterrupt:
        exit(0)
	
        
