
#!usr/bin/python3
# -*- coding: utf-8 -*-

from scapy.all import *
import scapy.contrib.igmp
import scapy.contrib.igmpv3 as IGMPv3
import sys
import os
import struct
import re
import random
import threading
from uuid import getnode
import getopt

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

class IGMP3(Packet):
    name = "IGMP3"
    fields_desc = [ ByteField("type", 0x11),
                    ByteField("mrtime", 20),
                   XShortField("chksum", None),
                      IPField("gaddr", "0.0.0.0"),
                     IntField("others", 0x0)]
                         
    def post_build(self, p, pay):
        '''
        p += pay
        if self.chksum is None:
            ck = checksum(p)
            p = p[:2]+chr(ck>>8)+chr(ck&0xff)+p[4:]
        '''
        return p
    


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
    return


def sniff_multicast_IF3(interface , filter_sniff ):
    sniff(filter=filter_sniff,iface=interface, prn=lambda p: p.show() , count=0)

    return


def usage():

    print("\n\tUsage: python3 igmp_generator.py -v <igmp_version> -t <igmp_type> -r <rate_tx> -i <interface>\n")

    return

def parse_type(x):
    return {
        'report': 0x16,
        'leave': 0x17,
        'mode_is_include': 1,
        'mode_is_exclude': 2,
        'change_to_include': 3,
        'change_to_exclude': 4,
        'allow_new_sources': 5,
        'block_old_sources': 6,        
    }[x]    

#***************************************************************************************************************
# Main:
#***************************************************************************************************************

if __name__ == '__main__':

    '''
    read_Test_param()

    # send report thread:
    t1 = threading.Thread(target=send_report_thread, args="")
    t1.start()
    time.sleep(0.5)
    #t1.join()  

    

    # sniff port multicast forwarding:
    print('\nSniffing muticast stream (filter ip=%s) on IF3 (%s) ...  \t(CTRL+C to stop)\n' % (IP_multicast, IF3))
    t1 = threading.Thread(target=sniff_multicast_IF3, args=(IF3,"ip and host "+IP_multicast, ))

    t1.start()
    time.sleep(0.5)   

    #Main thread: sending multicast stream
    
    MAC_dst_multicast = get_MAC_dst_multicast(IP_multicast)
    
    data="Hello "+''.ljust(600-18-12-20,'x')+" World"

    p = Ether(src=MAC_src,dst=MAC_dst_multicast, type=0x0800)/IP(dst=IP_multicast,len=20)/Raw(data)
    
    FCS=0x9fe83f6f

    p /= FCS.to_bytes(4,'big')

    print("Sending Multicast("+IP_multicast+") packets to "+MAC_dst_multicast+" through IF1 ("+IF1+")  \t(CTRL+C to stop)")
    
    sendp(p, loop=1, inter=inter_multicast, verbose = False,iface=IF1)    

    '''

    igmp_version=2
    igmp_type=0x16
    IP_multicast = "225.1.2.3"
    rate=0.1
    interface="iface_aux"
    sources="0"
    
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'v:t:s:m:r:i:h', ['version=', 'type=', 'sources=' ,'multicast=','rate=', 'interface=', 'help'])
    except getopt.GetoptError:
        usage()
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit(2)        
        elif opt in ('-v', '--version'):
            igmp_version = int(arg)
        elif opt in ('-t', '--type'):
            igmp_type = arg
        elif opt in ('-m', '--multicast'):
            IP_multicast=arg
        elif opt in ('-s', '--sources'):
            sources=arg            
        elif opt in ('-r', '--rate'):
            rate = float(arg)
        elif opt in ('-i', '--interface'):
            interface = arg            
        else:
            usage()
            sys.exit(2)


    MAC_dst_multicast = get_MAC_dst_multicast(IP_multicast)

    Sources_ip=[]
    for i in range(int(sources)):

        Sources_ip.append("192.168."+str(i)+".64")  # Only for IGMP v3
    

    # https://github.com/secdev/scapy/blob/master/scapy/contrib/igmpv3.py


    # igmpv2type=report/leave  

    # igmpv3type=allow/block (sources)

    if igmp_version == 2:
        p = Ether(dst=MAC_dst_multicast, src="00:11:22:33:44:55", type=0x0800)/IP(dst=IP_multicast,id=0,options=[IPOption_Router_Alert()])/scapy.contrib.igmp.IGMP(type=parse_type(igmp_type),gaddr=IP_multicast)

    elif igmp_version == 3:
        #gr=IGMPv3.IGMPv3gr(rtype=parse_type(igmp_type),maddr=IP_multicast,srcaddrs=[Source_ip],auxdlen=0)
        #mr = IGMPv3.IGMPv3mr(res2=0,records=[gr])    
        #p = Ether(dst=MAC_dst_multicast, src="00:11:22:33:44:55", type=0x0800)/IP(dst=IP_multicast,id=0,options=[IPOption_Router_Alert()])/IGMPv3.IGMPv3(type=0x22,mrcode=0)/mr
        #if sources=="0":
        #    gr=IGMPv3.IGMPv3gr(rtype=parse_type(igmp_type),maddr=IP_multicast,srcaddrs=[],auxdlen=0)
        #else:
        gr=IGMPv3.IGMPv3gr(rtype=parse_type(igmp_type),maddr=IP_multicast,srcaddrs=Sources_ip,auxdlen=0)
        mr = IGMPv3.IGMPv3mr(res2=0,records=[gr])  
        p = Ether(dst=MAC_dst_multicast, src="00:11:22:33:44:55", type=0x0800)/IP(dst=IP_multicast,id=0,options=[IPOption_Router_Alert()])/IGMPv3.IGMPv3(type=0x22,mrcode=0)/mr

    #print("\n\n \tSending IGMP v{} {} [IP multicast = {}] through {} [ 1 fps ]\t CTRL+C to STOP".format(igmp_version, igmp_type, IP_multicast, interface))
    try:
        #sendp(p, loop=1, inter=rate, verbose = True,iface=interface)
        sendp(p, count=5, inter=rate, verbose = True,iface=interface)
    except KeyboardInterrupt:
        exit(0)    


