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
import time
from uuid import getnode

#import hsr_extras

#***************************************************************************************************************
# Global variables:
#***************************************************************************************************************

packet_tmp1 = Ether()/IP()
packet_tmp2 = Ether()/IP()

count_I=0
count_A = 0
count_B = 0
count_tmp = 0


#-----------------------------------------
# HSR test - Global Variables:

HSR_file = "HSR_param"


IPv4_tag = 0x0800
HSR_tag = 0x892F


smallest_frame = 64
biggest_frame = 1500

SeqN_HSR=0

DEBUG_MODE = True

interface_I = "Ethernet 2"
interface_A = "Ethernet 6"
interface_B = "Ethernet 7"
MAC_1="11:11:11:11:11:11"
MAC_2="22:22:22:22:22:22"
IP_multicast_hsr = "224.1.2.3"
IP_unicast_hsr = "192.168.1.11"
NumberOfPackets = 100
interval = 0.001  # packet/seg
EtherType = 0x0000
len_packet = 64

delay_hsr = 0.1


data="Hello "+''.ljust(600,'x')+" World"

ProxyTableSize = 64
JumboEnabled=1


def printHelp():

    print ("""
 Usage(Linux): 
 sudo python3 HSR.py [type_test] [test] [file_param]
 
 Usage(Windows): 
 python HSR.py [type_test] [test] [file_param]\n
 
 [TYPE_TEST]    [TEST]
     |            |
     |            |
 [hsr_tagging]    |
     |            | 
     |           [1] Send smallest (64bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)
     |
     |           [2] Send biggest (1518bytes incl. FCS or 9018 with Jumbo) frames with 2 different source MAC addresses through Interlink port (I)
     |            |
     |            |
     |            |
 [hsr_forwarding] |
                  |
                 [1] Send multicast frames with correct HSR-tag through Redundant port (A)
 
                 [2] Send multicast frames with correct HSR-tag through Redundant port (B)
 
                 [3] Send unicast frames with correct HSR-tag through Redundant port (A)
 
                 [4] Send unicast frames with correct HSR-tag through Redundant port (B)
 
                 [5] Send identical multicast frames with correct HSR-tag through Redundant port (A)
 
                 [6] Send identical multicast frames with correct HSR-tag through Redundant port (B)
 
                 [7] Send a frame with a defined source MAC address through (I) and unicast frames with the same defined destination MAC address and with correct HSR-tag through (A)
 
                 [8] Send a frame with a defined source MAC address through (I) and unicast frames with the same defined destination MAC address and with correct HSR-tag through (B)
 
                 [9] Send a frame with a defined source MAC address through (I) and unicast frames with the same defined source MAC address and with correct HSR-tag through (A)
 
                 [10] Send a frame with a defined source MAC address through (I) and unicast frames with the same defined source MAC address and with correct HSR-tag through (B)
 
                 [11] Send pairs of identical multicast frames (but LAN ID) through A and B with increasing delay between them

                 [12] Send pairs of identical multicast frames (but LAN ID) through A with increasing delay between them

                 [13] Send pairs of identical multicast frames (but LAN ID) through B with increasing delay between them                                  
 
 Examples:
    python HSR.py [type_test] [test] [file_param]
    
    python HSR.py hsr_tagging 1 HSR_param
    python HSR.py HSR_tagging 2 HSR_param
    python HSR.py HSR_FORWARDING 1 HSR_param
    ...

    NOTE: [type_test] is case-insensitive
    """)
    return 0

def read_HSR_param():

    global DEBUG_MODE, interface_I, interface_A, interface_B, MAC_1, MAC_2, IP_multicast_hsr, IP_unicast_hsr, NumberOfPackets, interval , EtherType, size, delay_hsr ,data, ProxyTableSize, JumboEnabled


    param=list()
    with open(HSR_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  

    if param[0]=="ON":
        DEBUG_MODE=True
    elif param[0]=="OFF":
        DEBUG_MODE=False
    else:
        DEBUG_MODE=True    
    interface_I = param[1]
    interface_A = param[2]
    interface_B = param[3]
    MAC_1=param[4]
    MAC_2=param[5]
    IP_multicast_hsr = param[6]
    IP_unicast_hsr = param[7]
    NumberOfPackets = int(param[8])
    interval = float(param[9])  # packet/seg
    EtherType = int(param[10],16)
    size = int(param[11])
    delay_hsr = (float(param[12])) 
    ProxyTableSize = int(param[13]) 
    JumboEnabled = int(param[14]) 

    data="Hello "+''.ljust(size-18-20-12,'x')+" World"  # -12:"Hello  World"   -20:IP header   -18:L2 header



def get_MAC_dst_multicast(ip_str):

    ip_octets = ip_str.split('.')
    mac="01:00:5E" # octet 0,1,2

    octet_3 = ':{:02x}'.format(int(ip_octets[1])&0x7F) # &7F : first bit = 0 
    octet_4 = ':{:02x}'.format(int(ip_octets[2]))
    octet_5 = ':{:02x}'.format(int(ip_octets[3]))

    mac=mac+octet_3+octet_4+octet_5
    
    return mac

def bytes2int(value_bytes):

    value_int = int.from_bytes(value_bytes,"big")
    
    return value_int

#**********************************************************************************************************************************************************************************
# HSR format functions:
#**********************************************************************************************************************************************************************************

# ----------------------------------------
# (000X) 1111 1111 1111      --> path id (4 bits)-> LAN A->X=0 -> 0x0FFF = 4095(Dec)   ||   LAN B->X=1 ->  0x1FFF = 8191(Dec)
#  1111 (XXXX XXXX XXXX)     --> LSDU_size (12 bits) -> 0xF000 xor LSDU_size (0x0XXX)
#  path_id & LSDU_size
# 2 Bytes (16 bits)
def pathID_plus_LSDUsize(LAN_id):
    
    global data
    
    path_id=0x0FFF
    
    if LAN_id=="A":
        path_id=0xAFFF     
    elif LAN_id=="B":
        path_id=0xBFFF
    elif LAN_id=="0":
        path_id=0x0FFF
    elif LAN_id=="1":
        path_id=0x1FFF        
    else:
        path_id=0x0FFF
    
    LSDU_size = len(data) + 6   
    
    HEX_ = path_id & (0xF000 ^ LSDU_size)
    
    bits16 = struct.pack('>H',HEX_)

    return bits16
# ----------------------------------------
# 2 Bytes (16 bits)
def SeqNumber(type):
    
    global SeqN_HSR, SeqN_PRP
    
    bits32 = struct.pack('>H',125)
    
    if type=="HSR":
        SeqN_HSR=SeqN_HSR+1
        bits32 = struct.pack('>H',SeqN_HSR)
        return bits32
        
    elif type=="PRP":
        SeqN_PRP=SeqN_PRP+1
        bits32 = struct.pack('>H',SeqN_PRP)
        return bits32
        
    else:
        return bits32
# ----------------------------------------
# 2 Bytes (16 bits)
def EthType(ethType):
    
    #Ethertype = 0x88FB # Unknown
    
    bits16 = struct.pack('>H',ethType)

    return bits16    

def get_HSR_tag(bytes_HSR_tag):
      
    path_lsdu = bytes_HSR_tag[0:2]
    path_lsdu_int = int.from_bytes(path_lsdu,"big")
    
    path = int.from_bytes(path_lsdu[0:1], "big") >>4
    lsdu = path_lsdu_int & 0xFFF
    seqNumber = int.from_bytes(bytes_HSR_tag[2:4],"big")
    type = int.from_bytes(bytes_HSR_tag[4:6],"big")
    
    return  path, lsdu, seqNumber ,type    
    

def create_HSR_tag(multi_uni_cast , path_id , randomLen):

    global data
    
    if multi_uni_cast=="multicast":
        ip_dst = IP_multicast_hsr
    elif multi_uni_cast=="unicast":
        ip_dst = IP_unicast_hsr
    else:  
        ip_dst = IP_unicast_hsr
        
    if randomLen == True:
        len=random.randint(smallest_frame,biggest_frame)
    else:
        len=size
    
    data=IP(dst=ip_dst,len=20)/Raw(load="Hello "+''.ljust(len-18-12-20,'x')+" World")
    
    payload = pathID_plus_LSDUsize(path_id)+SeqNumber("HSR")+EthType(EtherType)+bytes(data)

    return payload


#**********************************************************************************************************************************************************************************
# HSR sniff and check functions:
#**********************************************************************************************************************************************************************************

def sniff_I(filter_sniff , function_check):
    
    sniff(filter=filter_sniff,iface=interface_I, prn=function_check, count=1)   
    return

def sniff_A_block(filter_sniff , function_check):
    
    global count_A
    
    count_A=0
    #print("\nREDUNDANT A:")
    sniff(filter=filter_sniff,iface=interface_A, prn=function_check, count=NumberOfPackets , timeout=10)
    
    return

def sniff_B_block(filter_sniff , function_check):
    global count_B
    
    count_B=0
    #print("\nREDUNDANT B:")
    sniff(filter=filter_sniff,iface=interface_B, prn=function_check, count=NumberOfPackets,timeout=10)
    return
     
    
def sniff_I_identical_Delay(filter_sniff, function_check):
    global count_tmp
    count_tmp=0
    if DEBUG_MODE: print("Packets received at interface_I (timeout=2 seg) :",end='')
    sniff(filter=filter_sniff,iface=interface_I, prn=function_check, timeout=2)   
    if DEBUG_MODE: print("\t {} packets received.".format(count_tmp))
    return    
    
def Count_packets_I(packet):
    global count_tmp
    count_tmp=count_tmp+1
    return 
    
    
def sniff_check_HSR(interface , filter_sniff , function_check):
  
    sniff(filter=filter_sniff,iface=interface, prn=function_check, count=1) 
    
    return
    
def sniff_check_no_frames(interface , filter_sniff ):
  
    sniff(filter=filter_sniff,iface=interface,  timeout=1)  #prn=lambda p: p.show() ,
    
    if interface == interface_I:
        print(">>(I) No packet received (timeout = 1 seg)")
    elif interface == interface_A:
        print(">>(A) No packet received (timeout = 1 seg)")
    elif interface == interface_B:
        print(">>(B) No packet received (timeout = 1 seg)") 
    else:
        print(">>(I) No packet received (timeout = 1 seg)")
    
    return  

def sniff_check_HSR_timeout(interface , filter_sniff , function_check):
    
    sniff(filter=filter_sniff,iface=interface, prn=function_check, timeout=3) 
    
    return
    
    
def check_HSR_untag_I(packet):
    
    global count_I
    count_I=count_I+1
    
    OK=True
    
    bytes_S = bytes(packet_tmp2)  
    path, lsdu, seqNumber ,type = get_HSR_tag(bytes_S[14:20])

    bytes_R = bytes(packet)
    
    # MACs check:
    if bytes_S[0:12]!=bytes_R[0:12]:
        OK=False
    
    # Ethertype check:
    if bytes_S[18:20] != bytes_R[12:14]:
        OK=False
    
    # Payload chek:
    if bytes_S[20:] != bytes_R[14:]:
        OK=False
    

    if OK==True:
        if DEBUG_MODE: print(">>(I) packet {} received: L2 Header and Payload OK! , HSR-tag (None)".format(count_I))
    else:
        if DEBUG_MODE: print(">>(I) packet {} received: L2 Header or Payload KO.".format(count_I))
        
def check_HSR_untag_A(packet):
    
    global count_A
    count_A=count_A+1
    
    OK=True
    
    bytes_S = bytes(packet_tmp2)  
    path, lsdu, seqNumber ,type = get_HSR_tag(bytes_S[14:20])

    bytes_R = bytes(packet)

    # MACs check:
    if bytes_S[0:12]!=bytes_R[0:12]:
        OK=False
    
    # Ethertype check:
    if bytes_S[18:20] != bytes_R[12:14]:
        OK=False
    
    # Payload chek:
    if bytes_S[20:] != bytes_R[14:]:
        OK=False
    

    if OK==True:
        if DEBUG_MODE: print(">>(A) packet {} received: L2 Header and Payload OK! , HSR-tag (None)".format(count_A))
    else:
        if DEBUG_MODE: print(">>(A) packet {} received: L2 Header or Payload KO.".format(count_A))
        
def check_HSR_untag_B(packet):
    
    global count_B
    count_B=count_B+1
    
    OK=True
    
    bytes_S = bytes(packet_tmp2)  
    path, lsdu, seqNumber ,type = get_HSR_tag(bytes_S[14:20])

    bytes_R = bytes(packet)

    # MACs check:
    if bytes_S[0:12]!=bytes_R[0:12]:
        OK=False
    
    # Ethertype check:
    if bytes_S[18:20] != bytes_R[12:14]:
        OK=False
    
    # Payload chek:
    if bytes_S[20:] != bytes_R[14:]:
        OK=False
    

    if OK==True:
        if DEBUG_MODE: print(">>(B) packet {} received: L2 Header and Payload OK! , HSR-tag (None)".format(count_B))
    else:
        if DEBUG_MODE: print(">>(B) packet {} received: L2 Header or Payload KO.".format(count_B))  

def check_frame_A(packet):
    global count_A
    count_A=count_A+1
    
    bytes_S = bytes(packet_tmp2)
    bytes_R = bytes(packet)
    
    HSR_tag = bytes_R[14:20] 
    path, lsdu, seqNumber ,type = get_HSR_tag(HSR_tag)    
    
    if bytes_R == bytes_S:
        if DEBUG_MODE: print(">>(A) packet {} received: L2 Header and Payload OK!".format(count_A),", HSR_tag-(pathID={}, LSDU size={}, SeqNumber={}, type={})".format(path ,lsdu , seqNumber, hex(type)))
    else:
        if DEBUG_MODE: print(">>(A) packet {} received: L2 Header or Payload KO.\n".format(count_A))
    return       

def check_frame_B(packet):
    global count_B
    count_B=count_B+1
    
    bytes_S = bytes(packet_tmp2)
    bytes_R = bytes(packet)
    
    HSR_tag = bytes_R[14:20] 
    path, lsdu, seqNumber ,type = get_HSR_tag(HSR_tag)    
    
    if bytes_R == bytes_S:
        if DEBUG_MODE: print(">>(B) packet {} received: L2 Header and Payload OK!".format(count_B),", HSR_tag-(pathID={}, LSDU size={}, SeqNumber={}, type={})".format(path ,lsdu , seqNumber, hex(type)))
    else:
        if DEBUG_MODE: print(">>(B) packet {} received: L2 Header or Payload KO.\n".format(count_B))
    return    


def checkHSR_tagging_A(packet):
    global count_A
    count_A=count_A+1

    bytes_I = bytes(packet_tmp2)

    bytes_A = bytes(packet)
    
    macs = bytes_A[0:12]
    suffix = bytes_A[12:14]
     
    HSR_tag = bytes_A[14:20] 
    path, lsdu, seqNumber ,type = get_HSR_tag(HSR_tag)    
    
    payload = bytes_A[20:]    

    if bytes_I == macs+struct.pack('>H',type)+payload:
        if DEBUG_MODE: print(">>(A) packet {} received: L2 Header and Payload OK!".format(count_A),"\t HSR_tag-(Ethertype={} , LSDU size={} , LAN_ID={} , SeqNumber={})".format(hex(bytes2int(suffix)),lsdu,hex(path),seqNumber))
    else:
        if DEBUG_MODE: print(">>(A) packet {} received: L2 Header or Payload KO.".format(count_A))
  

def checkHSR_tagging_B(packet):
    global count_B
    count_B=count_B+1

    bytes_I = bytes(packet_tmp2)

    bytes_B = bytes(packet)
    
    macs = bytes_B[0:12]
    suffix = bytes_B[12:14]
     
    HSR_tag = bytes_B[14:20] 
    path, lsdu, seqNumber ,type = get_HSR_tag(HSR_tag)    
    
    payload = bytes_B[20:]    

    if bytes_I == macs+struct.pack('>H',type)+payload:
        if DEBUG_MODE: print(">>(B) packet {} received: L2 Header and Payload OK!".format(count_B),"\t HSR_tag-(Ethertype={} , LSDU size={} , LAN_ID={} , SeqNumber={})".format(hex(bytes2int(suffix)),lsdu,hex(path),seqNumber))
    else:
        if DEBUG_MODE: print(">>(B) packet {} received: L2 Header or Payload KO.".format(count_B))


#**********************************************************************************************************************************************************************************
# HSR Supervision frames:
#**********************************************************************************************************************************************************************************


def fill_ProxyTable_HPS():

    print("\n\t\t HSR Supervision frames Test\n")
    read_HSR_param()

    size_pkt =random.randint(64,1518+JumboEnabled*7500)

    mac_base = "d0:00:50:CE:00"
    offset=0

    for i in range(ProxyTableSize):

        payload=create_HSR_tag("unicast ","0",randomLen=True)

        size_pkt =random.randint(64,1518+JumboEnabled*7500)

        inc_byte = ':{:02x}'.format(i+offset)

        MAC_src_tmp = mac_base+inc_byte

        packet = Ether(src=MAC_src_tmp,dst=MAC_1,type=0xffff)/Raw(load="Hello "+''.ljust(size_pkt-18-12-20,'x')+" World")
        sendp(packet, verbose = False,iface=interface_I,count=1)  


#**********************************************************************************************************************************************************************************
# HSR TAGGING TESTS:
#**********************************************************************************************************************************************************************************

def HSR_tagging_1():

    global packet_tmp1, packet_tmp2

    print("\n\t\t [1] HSR Tagging - Test 1\n")
    read_HSR_param()
    
    #----------------------------------------------------------------------------------------------------------------
    # Send smallest (64bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend smallest (64bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)\n\nMAC_src_1 = {}".format(MAC_1))
    packet_tmp2 = Ether(src=MAC_1,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp2)
    if DEBUG_MODE: print("\n>(I) {} packets sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(NumberOfPackets,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))
    
    t1 = threading.Thread(target=sniff_A_block, args=("ether src "+MAC_1, checkHSR_tagging_A, ))
    t2 = threading.Thread(target=sniff_B_block, args=("ether src "+MAC_1, checkHSR_tagging_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()    
    time.sleep(0.5)

    sendp(packet_tmp2, verbose = False,iface=interface_I,count=5)   
    
    t1.join()
    t2.join()
    
    packet_tmp2 = Ether(src=MAC_2,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp2)

    if DEBUG_MODE: print("\nMAC_src_2 = {}".format(MAC_2))
    if DEBUG_MODE: print("\n>(I) {} packets sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(NumberOfPackets,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))
    
    t1 = threading.Thread(target=sniff_A_block, args=("ether src "+MAC_2, checkHSR_tagging_A, ))
    t2 = threading.Thread(target=sniff_B_block, args=("ether src "+MAC_2, checkHSR_tagging_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()    
    time.sleep(0.5)

    sendp(packet_tmp2, verbose = False,iface=interface_I,count=5)   
    
    t1.join()
    t2.join()            
    
def HSR_tagging_2():

    global packet_tmp1, packet_tmp2

    print("\n\t\t [1] HSR Tagging - Test 2\n")
    read_HSR_param()

    #----------------------------------------------------------------------------------------------------------------
    # Send biggest (1518bytes incl. FCS or 9018 with Jumbo) frames with 2 different source MAC addresses through Interlink port (I)   
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend biggest (1518bytes incl. FCS or 9018 with Jumbo) frames with 2 different source MAC addresses through Interlink port (I)\n\nMAC_src_1 = {}".format(MAC_1))
    packet_tmp2 = Ether(src=MAC_1,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(biggest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp2)
    if DEBUG_MODE: print("\n>(I) {} packets sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(NumberOfPackets,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))

    t1 = threading.Thread(target=sniff_A_block, args=("ether src "+MAC_1, checkHSR_tagging_A, ))
    t2 = threading.Thread(target=sniff_B_block, args=("ether src "+MAC_1, checkHSR_tagging_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()            
    time.sleep(0.5)

    sendp(packet_tmp2, verbose = False,iface=interface_I, count=5)  
                
    t1.join()
    t2.join()            
    
    packet_tmp2 = Ether(src=MAC_2,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(biggest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp2)

    if DEBUG_MODE: print("\nMAC_src_2 = {}".format(MAC_2))
    if DEBUG_MODE: print("\n>(I) {} packets sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(NumberOfPackets,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))

    t1 = threading.Thread(target=sniff_A_block, args=("ether src "+MAC_2, checkHSR_tagging_A, ))
    t2 = threading.Thread(target=sniff_B_block, args=("ether src "+MAC_2, checkHSR_tagging_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()            
    time.sleep(0.5)

    sendp(packet_tmp2, verbose = False,iface=interface_I, count=5)  
                
    t1.join()
    t2.join()
    

#**********************************************************************************************************************************************************************************
# HSR FORWARDING TESTS:
#**********************************************************************************************************************************************************************************

def HSR_forwarding_1():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 1\n")
    read_HSR_param()   
    
    #----------------------------------------------------------------------------------------------------------------
    # Send multicast frames with correct HSR-tag through Redundant port (A)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\n\nSend multicast frames with correct HSR-tag through Redundant port (A)\n")
    
    count_I, count_A, count_B = 0,0,0         
    
    for i in range(NumberOfPackets):
        payload=create_HSR_tag("multicast","0",randomLen=True)
        packet_tmp2 = Ether(src=MAC_1,dst=get_MAC_dst_multicast(IP_multicast_hsr),type=HSR_tag)/Raw(load=payload)
        bytes_p = bytes(packet_tmp2)
        
        path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
        
        if DEBUG_MODE: print("\n>(A) packet {} sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(i+1,bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        
        
        t1 = threading.Thread(target=sniff_check_HSR_timeout, args=(interface_I,"ether src "+MAC_1, check_HSR_untag_I, ))
        t2 = threading.Thread(target=sniff_check_HSR_timeout, args=(interface_B,"ether src "+MAC_1, check_frame_B, )) 
        t1.start()
        time.sleep(0.5)
        t2.start()      
        time.sleep(0.5)
        
        sendp(packet_tmp2, verbose = False,iface=interface_A,count=1)   
        
        t1.join()
        t2.join()
     

def HSR_forwarding_2():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 2\n")
    read_HSR_param()   

    #----------------------------------------------------------------------------------------------------------------
    # Send multicast frames with correct HSR-tag through Redundant port (B)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\n\nSend multicast frames with correct HSR-tag through Redundant port (B)\n")
    
    count_I, count_A, count_B = 0,0,0         
    
    for i in range(NumberOfPackets):
        payload=create_HSR_tag("multicast","1",randomLen=True)
        packet_tmp2 = Ether(src=MAC_1,dst=get_MAC_dst_multicast(IP_multicast_hsr),type=HSR_tag)/Raw(load=payload)
        bytes_p = bytes(packet_tmp2)
        
        path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
        
        if DEBUG_MODE: print("\n>(B) packet {} sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(i+1,bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        
        
        t1 = threading.Thread(target=sniff_check_HSR, args=(interface_I,"ether src "+MAC_1, check_HSR_untag_I, ))
        t2 = threading.Thread(target=sniff_check_HSR, args=(interface_A,"ether src "+MAC_1, check_frame_A, )) 
        t1.start()
        time.sleep(0.5)
        t2.start()          
        time.sleep(0.5)

        sendp(packet_tmp2, verbose = False,iface=interface_B,count=1)   
        
        t1.join()
        t2.join()       
           

def HSR_forwarding_3():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 3\n")
    read_HSR_param()   

    #----------------------------------------------------------------------------------------------------------------
    # Send unicast frames with correct HSR-tag through Redundant port (A)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\n\nSend unicast frames with correct HSR-tag through Redundant port (A)\n")
    
    count_I, count_A, count_B = 0,0,0         
    
    for i in range(NumberOfPackets):
        payload=create_HSR_tag("unicast","0",randomLen=True)
        packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=HSR_tag)/Raw(load=payload)
        bytes_p = bytes(packet_tmp2)
        
        path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
        
        if DEBUG_MODE: print("\n>(A) packet {} sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(i+1,bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        
        
        t1 = threading.Thread(target=sniff_check_no_frames, args=(interface_I,"ether src "+MAC_1, ))
        t2 = threading.Thread(target=sniff_check_HSR, args=(interface_B,"ether src "+MAC_1, check_frame_B, )) 
        t1.start()
        time.sleep(0.5)
        t2.start()      
        time.sleep(0.5)

        sendp(packet_tmp2, verbose = False,iface=interface_A,count=1)   
        
        t1.join()
        t2.join()    


def HSR_forwarding_4():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 4\n")
    read_HSR_param()   

    #----------------------------------------------------------------------------------------------------------------
    # Send unicast frames with correct HSR-tag through Redundant port (B)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\n\nSend unicast frames with correct HSR-tag through Redundant port (B)\n")
    
    count_I, count_A, count_B = 0,0,0         
    
    for i in range(NumberOfPackets):
        payload=create_HSR_tag("unicast","1",randomLen=True)
        packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=HSR_tag)/Raw(load=payload)
        bytes_p = bytes(packet_tmp2)
        
        path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
        
        if DEBUG_MODE: print("\n>(B) packet {} sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(i+1,bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        
        
        t1 = threading.Thread(target=sniff_check_no_frames, args=(interface_I,"ether src "+MAC_1, ))
        t2 = threading.Thread(target=sniff_check_HSR, args=(interface_A,"ether src "+MAC_1, check_frame_A, )) 
        t1.start()
        time.sleep(0.5)
        t2.start()      
        time.sleep(0.5)

        sendp(packet_tmp2, verbose = False,iface=interface_B,count=1)   
        
        t1.join()
        t2.join()  
       
    

def HSR_forwarding_5():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 5\n")
    read_HSR_param()   

    #----------------------------------------------------------------------------------------------------------------
    # Send identical multicast frames with correct HSR-tag through Redundant port (A)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\n\nSend identical multicast frames with correct HSR-tag through Redundant port (A)\n")
    
    count_I, count_A, count_B = 0,0,0         
    
    payload=create_HSR_tag("multicast","0",randomLen=True)
    packet_tmp2 = Ether(src=MAC_1,dst=get_MAC_dst_multicast(IP_multicast_hsr),type=HSR_tag)/Raw(load=payload)
    bytes_p = bytes(packet_tmp2)
    
    path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
    
    if DEBUG_MODE: print("\n>(A) 2 packet sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        
    
    t1 = threading.Thread(target=sniff_check_HSR_timeout, args=(interface_I,"ether src "+MAC_1, check_HSR_untag_I, ))
    t2 = threading.Thread(target=sniff_check_HSR_timeout, args=(interface_B,"ether src "+MAC_1, check_frame_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()     
    time.sleep(0.5) 

    sendp(packet_tmp2, verbose = False,iface=interface_A,count=2)   
    
    t1.join()
    t2.join()
    

def HSR_forwarding_6():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 6\n")
    read_HSR_param()   

    #----------------------------------------------------------------------------------------------------------------
    # Send identical multicast frames with correct HSR-tag through Redundant port (B)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\n\nSend identical multicast frames with correct HSR-tag through Redundant port (B)\n")
    
    count_I, count_A, count_B = 0,0,0         
    
    payload=create_HSR_tag("multicast","1",randomLen=True)
    packet_tmp2 = Ether(src=MAC_1,dst=get_MAC_dst_multicast(IP_multicast_hsr),type=HSR_tag)/Raw(load=payload)
    bytes_p = bytes(packet_tmp2)
    
    path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
    
    if DEBUG_MODE: print("\n>(B) 2 packet sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        
    
    t1 = threading.Thread(target=sniff_check_HSR_timeout, args=(interface_I,"ether src "+MAC_1, check_HSR_untag_I, ))
    t2 = threading.Thread(target=sniff_check_HSR_timeout, args=(interface_A,"ether src "+MAC_1, check_frame_A, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()      
    time.sleep(0.5)

    sendp(packet_tmp2, verbose = False,iface=interface_B,count=2)   
    
    t1.join()
    t2.join()   

    

def HSR_forwarding_7():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 7\n")
    read_HSR_param()   

    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend a frame with a defined source MAC address through (I) and unicast frames with the same defined destination MAC address and with correct HSR-tag through (A)")        
    
    packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp1)  
    if DEBUG_MODE: print("\n>(I) packet sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))    
    sendp(packet_tmp1, verbose = False,iface=interface_I,count=1) 
    

    count_I, count_A, count_B = 0,0,0         
    
    #for i in range(NumberOfPackets):
    i=0

    payload=create_HSR_tag("unicast","0",randomLen=True)
    packet_tmp = Ether(src=MAC_2,dst=MAC_1,type=HSR_tag)/Raw(load=payload)
    bytes_p = bytes(packet_tmp)
    
    path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
    
    if DEBUG_MODE: print("\n>(A) packet {} sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(i+1,bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        
    packet_tmp2=packet_tmp
    t1 = threading.Thread(target=sniff_check_HSR_timeout, args=(interface_I,"ether src "+MAC_2, check_HSR_untag_I, ))
    t2 = threading.Thread(target=sniff_check_no_frames, args=(interface_B,"ether src "+MAC_2, ))
    t1.start()
    time.sleep(0.5)
    t2.start()      
    time.sleep(0.5)

    sendp(packet_tmp, verbose = False,iface=interface_A,count=1)   
    
    t1.join()
    t2.join()  
    sys.exit()
    

def HSR_forwarding_8():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 8\n")
    read_HSR_param()   

    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend a frame with a defined source MAC address through (I) and unicast frames with the same defined destination MAC address and with correct HSR-tag through (B)")        
    
    packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp2)  
    if DEBUG_MODE: print("\n>(I) packet sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))    
    sendp(packet_tmp2, verbose = False,iface=interface_I,count=1) 
    

    count_I, count_A, count_B = 0,0,0         
    
    #for i in range(NumberOfPackets):
    i=0

    payload=create_HSR_tag("unicast","1",randomLen=True)
    packet_tmp = Ether(src=MAC_2,dst=MAC_1,type=HSR_tag)/Raw(load=payload)
    bytes_p = bytes(packet_tmp)
    
    path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
    
    if DEBUG_MODE: print("\n>(B) packet {} sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(i+1,bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        
    packet_tmp2=packet_tmp
    t3 = threading.Thread(target=sniff_check_HSR_timeout, args=(interface_I,"ether src "+MAC_2, check_HSR_untag_I, ))
    t4 = threading.Thread(target=sniff_check_no_frames, args=(interface_A,"ether src "+MAC_2, ))
    t3.start()
    time.sleep(0.5)
    t4.start()     
    time.sleep(0.5) 

    sendp(packet_tmp, verbose = False,iface=interface_B,count=1)   
    
    t3.join()
    t4.join()
    sys.exit()
      
    
def HSR_forwarding_9():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 9\n")
    read_HSR_param()   

    #----------------------------------------------------------------------------------------------------------------
    # Send a frame with a defined source MAC address through (I) and unicast frames with the same defined source MAC address and with correct HSR-tag through (A)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\n\nSend a frame with a defined source MAC address through (I) and unicast frames with the same defined source MAC address and with correct HSR-tag through (A)\n")
    
    packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp2)  
    if DEBUG_MODE: print("\n>(I) packet sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))    
    sendp(packet_tmp2, verbose = False,iface=interface_I,count=1) 
    

    count_I, count_A, count_B = 0,0,0         
    
    for i in range(NumberOfPackets):
        payload=create_HSR_tag("unicast","0",randomLen=True)
        packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=HSR_tag)/Raw(load=payload)
        bytes_p = bytes(packet_tmp2)
        
        path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
        
        if DEBUG_MODE: print("\n>(A) packet {} sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(i+1,bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        

        t1 = threading.Thread(target=sniff_check_no_frames, args=(interface_I,"ether src "+MAC_1, ))
        t2 = threading.Thread(target=sniff_check_no_frames, args=(interface_B,"ether src "+MAC_1, ))
        t1.start()
        time.sleep(0.5)
        t2.start()     
        time.sleep(0.5) 

        sendp(packet_tmp2, verbose = False,iface=interface_A,count=1)   
        
        t1.join()
        t2.join()     
    

def HSR_forwarding_10():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 10\n")
    read_HSR_param()   

    #----------------------------------------------------------------------------------------------------------------
    # Send a frame with a defined source MAC address through (I) and unicast frames with the same defined source MAC address and with correct HSR-tag through (B)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\n\nSend a frame with a defined source MAC address through (I) and unicast frames with the same defined source MAC address and with correct HSR-tag through (B)\n")
    
    packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp2)  
    if DEBUG_MODE: print("\n>(I) packet sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))    
    sendp(packet_tmp2, verbose = False,iface=interface_I,count=1) 
    

    count_I, count_A, count_B = 0,0,0         
    
    for i in range(NumberOfPackets):
        payload=create_HSR_tag("unicast","1",randomLen=True)
        packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=HSR_tag)/Raw(load=payload)
        bytes_p = bytes(packet_tmp2)
        
        path, lsdu, seqNumber ,type = get_HSR_tag(bytes_p[14:20])
        
        if DEBUG_MODE: print("\n>(B) packet {} sent: (mac_dst={} , mac_src={} , Ethertype={} , HSR_tag-(pathID={} , LSDU size={} , SeqNumber={} , Ethertype={})".format(i+1,bytes_p[0:6],bytes_p[6:12],hex(bytes2int(bytes_p[12:14])), path, lsdu, seqNumber, hex(type)))        

        t1 = threading.Thread(target=sniff_check_no_frames, args=(interface_I,"ether src "+MAC_1, ))
        t2 = threading.Thread(target=sniff_check_no_frames, args=(interface_A,"ether src "+MAC_1, ))
        t1.start()
        time.sleep(0.5)
        t2.start()     
        time.sleep(0.5) 

        sendp(packet_tmp2, verbose = False,iface=interface_B,count=1)   
        
        t1.join()
        t2.join() 
    
    

def HSR_forwarding_11():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 11\n")
    read_HSR_param()   


    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend pairs of identical multicast frames (but LAN ID) through A and B with increasing delay between them")
    
    SeqN_HSR=0
    payload=create_HSR_tag("multicast","0",randomLen=False)
    packet_tmp1 = Ether(src=MAC_1,dst=get_MAC_dst_multicast(IP_multicast_hsr),type=HSR_tag)/Raw(load=payload)    
    
    SeqN_HSR=0
    payload=create_HSR_tag("multicast","1",randomLen=False)
    packet_tmp2 = Ether(src=MAC_1,dst=get_MAC_dst_multicast(IP_multicast_hsr),type=HSR_tag)/Raw(load=payload) 
    
    delay=delay_hsr
    
    while(delay<0.6):

        if DEBUG_MODE: print("\nDelay = {}".format(delay))
        #start_time = time.time()
        t1 = threading.Thread(target=sniff_I_identical_Delay, args=("ether src "+MAC_1, Count_packets_I, ))
        t1.start()  
        time.sleep(0.5)
                      
        sendp(packet_tmp1,count = 1 , verbose = False,iface=interface_A)
        time.sleep(delay)
        #print("--- %s seconds ---" % (time.time() - start_time))
        sendp(packet_tmp2,count = 1 , verbose = False,iface=interface_B) 
        
        t1.join()
        delay=delay+delay_hsr   

def busy_sleep(seconds_to_sleep):
    start = time.time()
    while (time.time() < start + seconds_to_sleep):
        pass

def HSR_forwarding_12():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 12\n")
    read_HSR_param()   


    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend pairs of identical multicast frames (but LAN ID) through A with increasing delay between them")
    
    SeqN_HSR=0
    payload=create_HSR_tag("multicast","0",randomLen=False)
    packet_tmp1 = Ether(src=MAC_1,dst=get_MAC_dst_multicast(IP_multicast_hsr),type=HSR_tag)/Raw(load=payload)    
    
    delay=delay_hsr
    
    while(delay<0.06):

        if DEBUG_MODE: print("\nDelay = {}".format(delay))
        #start_time = time.time()
        t1 = threading.Thread(target=sniff_I_identical_Delay, args=("ether src "+MAC_1, Count_packets_I, ))
        t1.start()  
        time.sleep(0.5)
                      
        sendp(packet_tmp1,count = 1 , verbose = False,iface=interface_A)
        #time.sleep(delay)
        busy_sleep(delay)
        
        #print("--- %s seconds ---" % (time.time() - start_time))
        sendp(packet_tmp1,count = 1 , verbose = False,iface=interface_A) 
        
        t1.join()
        delay=delay+delay_hsr               

def HSR_forwarding_13():

    global packet_tmp1, packet_tmp2, SeqN_HSR
    global count_I, count_A, count_B, count_tmp

    print("\n\t\t [2] HSR Forwarding - Test 13\n")
    read_HSR_param()   


    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend pairs of identical multicast frames (but LAN ID) through B with increasing delay between them")

    SeqN_HSR=0
    payload=create_HSR_tag("multicast","1",randomLen=False)
    packet_tmp2 = Ether(src=MAC_1,dst=get_MAC_dst_multicast(IP_multicast_hsr),type=HSR_tag)/Raw(load=payload) 
    
    delay=delay_hsr
    
    while(delay<0.6):

        if DEBUG_MODE: print("\nDelay = {}".format(delay))
        #start_time = time.time()
        t1 = threading.Thread(target=sniff_I_identical_Delay, args=("ether src "+MAC_1, Count_packets_I, ))
        t1.start()  
        time.sleep(0.5)
                      
        sendp(packet_tmp2,count = 1 , verbose = False,iface=interface_B)
        time.sleep(delay)
        #print("--- %s seconds ---" % (time.time() - start_time))
        sendp(packet_tmp2,count = 1 , verbose = False,iface=interface_B) 
        
        t1.join()
        delay=delay+delay_hsr     

def HSR_tagging():

    ans=True
    
    while ans:
        print ("""
    #######################################

    Select test:

     [0] HSR Supervision Test

     [1] HSR Tagging - Test 1:
         Send smallest (64bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)

     [2] HSR Tagging - Test 2:
         Send biggest (1518bytes incl. FCS or 9018 with Jumbo) frames with 2 different source MAC addresses through Interlink port (I)

     [e] Return to Menu
        """)
        ans=input("Select an option: ") 

        if ans=="0": 

            fill_ProxyTable_HPS()    

        elif ans=="1": 

            HSR_tagging_1()    
            
        elif ans=="2":

            HSR_tagging_2()

        elif ans=="e":
            return 0
        elif ans !="":
            print("\n Not Valid Option Try again") 

def HSR_forwarding():

    ans=True
    
    while ans:
        print ("""
\n****************************************************************************************************************************************************************************

    Select test:

     [1] HSR Forwarding - Test 1:
         Send multicast frames with correct HSR-tag through Redundant port (A)

     [2] HSR Forwarding - Test 2:
         Send multicast frames with correct HSR-tag through Redundant port (B)

     [3] HSR Forwarding - Test 3:
         Send unicast frames with correct HSR-tag through Redundant port (A)

     [4] HSR Forwarding - Test 4:
         Send unicast frames with correct HSR-tag through Redundant port (B)

     [5] HSR Forwarding - Test 5:
         Send identical multicast frames with correct HSR-tag through Redundant port (A)

     [6] HSR Forwarding - Test 6:
         Send identical multicast frames with correct HSR-tag through Redundant port (B)

     [7] HSR Forwarding - Test 7:
         Send a frame with a defined source MAC address through (I) and unicast frames with the same defined destination MAC address and with correct HSR-tag through (A)

     [8] HSR Forwarding - Test 8:
         Send a frame with a defined source MAC address through (I) and unicast frames with the same defined destination MAC address and with correct HSR-tag through (B)

     [9] HSR Forwarding - Test 9:
         Send a frame with a defined source MAC address through (I) and unicast frames with the same defined source MAC address and with correct HSR-tag through (A)

     [10] HSR Forwarding - Test 10:
          Send a frame with a defined source MAC address through (I) and unicast frames with the same defined source MAC address and with correct HSR-tag through (B)

     [11] HSR Forwarding - Test 11:
          Send pairs of identical multicast frames (but LAN ID) through A and B with increasing delay between them

     [12] HSR Forwarding - Test 12:
          Send pairs of identical multicast frames (but LAN ID) through A with increasing delay between them

     [13] HSR Forwarding - Test 13:
          Send pairs of identical multicast frames (but LAN ID) through B with increasing delay between them                    

     [e] Return to Menu
        """)
        ans=input("Select an option: ") 

        if ans=="1": 

            HSR_forwarding_1()    
            
        elif ans=="2":

            HSR_forwarding_2()

        elif ans=="3":

            HSR_forwarding_3()    

        elif ans=="4":

            HSR_forwarding_4()

        elif ans=="5":

            HSR_forwarding_5()  

        elif ans=="6":

            HSR_forwarding_6()

        elif ans=="7":

            HSR_forwarding_7()  

        elif ans=="8":

            HSR_forwarding_8()

        elif ans=="9":

            HSR_forwarding_9()       

        elif ans=="10":

            HSR_forwarding_10()

        elif ans=="11":

            HSR_forwarding_11()      

        elif ans=="12":

            HSR_forwarding_12()  

        elif ans=="13":

            HSR_forwarding_13()                                                                            

        elif ans=="e":
            return 0
        elif ans !="":
            print("\n Not Valid Option Try again")             
    
def selectHSR_type_test():

    ans=True
    
    while ans:
        print ("""
    #######################################

    Select HSR type test:

     [1] HSR Tagging
     [2] HSR Forwarding
     [e] Return to Menu
        """)
        ans=input("Select an option: ") 

        if ans=="1": 

            HSR_tagging()    
            
        elif ans=="2":

            HSR_forwarding()    

        elif ans.lower()=="e".lower():
            return 0
        elif ans !="":
            print("\n Not Valid Option Try again") 


#***************************************************************************************************************
# Main:
#***************************************************************************************************************

if __name__ == '__main__':


    if len(sys.argv) == 2:

        if sys.argv[1].lower() == "-h".lower():

            printHelp()
            exit(0)
        
    if len(sys.argv) == 3:

        if sys.argv[1].lower() == "1".lower():

            if os.path.exists(sys.argv[2]) == True:

                #hsr_extras.fill_ProxyTable_HPS("Ethernet 7")
                HSR_file = sys.argv[2]        
                fill_ProxyTable_HPS()                
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0) 

        elif sys.argv[1].lower() == "2a".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_tagging_1()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0) 

        elif sys.argv[1].lower() == "2b".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_tagging_2()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)                 

        elif sys.argv[1].lower() == "3a".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_1()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "3b".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_2()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "3c".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_5()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)   
        elif sys.argv[1].lower() == "3d".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_6()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0) 
        elif sys.argv[1].lower() == "4a".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_7()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0) 
        elif sys.argv[1].lower() == "4b".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_8()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)   
        elif sys.argv[1].lower() == "4c".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_3()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0) 
        elif sys.argv[1].lower() == "4d".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_4()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)   
        elif sys.argv[1].lower() == "5".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_11()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)   
        elif sys.argv[1].lower() == "6a".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_12()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0) 
        elif sys.argv[1].lower() == "6b".lower():

            if os.path.exists(sys.argv[2]) == True:

                HSR_file = sys.argv[2]        
                HSR_forwarding_13()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0) 

        elif sys.argv[1].lower() == "7".lower():

            if os.path.exists(sys.argv[2]) == True:

                hsr_extras.sendWrongEthertype("Ethernet 7",10)
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)     

        elif sys.argv[1].lower() == "8".lower():

            if os.path.exists(sys.argv[2]) == True:

                hsr_extras.sendWrongLSDUsize("Ethernet 7",10)
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)            

        elif sys.argv[1].lower() == "9a".lower():

            if os.path.exists(sys.argv[2]) == True:

                hsr_extras.sendWrongLanID_A("Ethernet 7",10)
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)   

        elif sys.argv[1].lower() == "9b".lower():

            if os.path.exists(sys.argv[2]) == True:

                hsr_extras.sendWrongLanID_B("Ethernet 7",10)
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)                                                                                                                                                                                                             
        else:
            print("\nERROR: format of script incorrect\n")        

    else:
            print("\nERROR: Number of arguments incorrect\n")

    
    selectHSR_type_test()
