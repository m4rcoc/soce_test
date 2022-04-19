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

#***************************************************************************************************************
# Global variables:
#***************************************************************************************************************
DEBUG_MODE = True

packet_tmp1 = Ether()/IP()
packet_tmp2 = Ether()/IP()

count_I=0
count_A = 0
count_B = 0
count_tmp = 0


#-----------------------------------------
# HSR-PRP test - Global Variables:

PRP_file = "PRP_param"

IPv4_tag = 0x0800
PRP_tag = 0x88FB

smallest_frame = 64
biggest_frame = 1500

SeqN_PRP=0

interface_I = "Ethernet 2"
interface_A = "Ethernet 6"
interface_B = "Ethernet 7"
MAC_1="11:11:11:11:11:11"
MAC_2="22:22:22:22:22:22"
NumberOfPackets = 100
interval = 0.001  # packet/seg
EtherType = 0x0000
len_packet = 64

delay_prp = 0.1


data="Hello "+''.ljust(600,'x')+" World"

ProxyTableSize = 64
JumboEnabled=1


def printHelp():

    print ("""
 Usage(Linux): 
 sudo python3 PRP.py [type_test] [test] [file_param]
 
 Usage(Windows): 
 python PRP.py [type_test] [test] [file_param]\n
 
 [TYPE_TEST]    [TEST]
     |            |
     |            |
 [prp_tagging]    |
     |            | 
     |           [1] Send smallest (64bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)
     |
     |           [2] Send biggest (1518bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)
     |            |
     |            |
     |            |
 [prp_forwarding] |
                  |
                 [1] Send frames with correct RCT through Redundant port (A)
 
                 [2] Send frames with correct RCT through Redundant port (B)
 
                 [3] Send frames without RCT through Redundant port (A)
 
                 [4] Send frames without RCT through Redundant port (B)
 
                 [5] Send identical frames with correct RCT through Redundant port (A)
 
                 [6] Send identical frames with correct RCT through Redundant port (B)
 
                 [7] Send pairs of identical frames (but LAN ID) through A and B with increasing delay between them
 
 Examples:
    python PRP.py [type_test] [test] [file_param]

    python PRP.py prp_tagging 1 PRP_param
    python PRP.py PRP_tagging 2 PRP_param
    python PRP.py PRP_FORWARDING 1 PRP_param
    ...

    NOTE: [type_test] is case-insensitive
    """)
    return 0

def read_PRP_param():
    global DEBUG_MODE, interface_I, interface_A, interface_B, MAC_1, MAC_2, NumberOfPackets, interval , EtherType, size, delay_prp, data, ProxyTableSize, JumboEnabled

    param=list()
    with open(PRP_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  

    #print(param) 
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
    #IP_dst=param[5]
    #UDP_dst_port=int(param[6])
    NumberOfPackets = int(param[6])
    interval = float(param[7])  # packet/seg
    EtherType = int(param[8],16)
    size = int(param[9])
    delay_prp = float(param[10])
    ProxyTableSize = int(param[11]) 
    JumboEnabled = int(param[12]) 
    
    #data="Hello "+str(RandString(size-12))+" World"  # -12 por el "Hello  World"
    data="Hello "+''.ljust(size-18-20-12,'x')+" World"  # -12:"Hello  World"   -20:IP header   -18:L2 header
    #print(len(data))    

def bytes2int(value_bytes):

    value_int = int.from_bytes(value_bytes,"big")
    
    return value_int

#**********************************************************************************************************************************************************************************
# PRP format functions:
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

# ----------------------------------------

def create_PRP_RCT(path_id):

    global data
    
    data=IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World"+str(bytes.fromhex('00000000').decode('utf-8')))
    #data=Raw(load="Hello "+''.ljust(100-18-12,'x')+" World")
    payload = bytes(data)+SeqNumber("PRP")+pathID_plus_LSDUsize(path_id)+EthType(PRP_tag)
    
    return payload

def get_PRP_RCT(bytes_RCT):  

    seqNumber = int.from_bytes(bytes_RCT[0:2],"big")
    
    path_lsdu = bytes_RCT[2:4]
    path_lsdu_int = int.from_bytes(path_lsdu,"big")
    
    path = int.from_bytes(path_lsdu[0:1], "big") >>4
    lsdu = path_lsdu_int & 0xFFF
    
    suffix = int.from_bytes(bytes_RCT[4:6],"big")
    
    return seqNumber, path, lsdu, suffix


#**********************************************************************************************************************************************************************************
# PRP sniff and check functions:
#**********************************************************************************************************************************************************************************

    
def sniff_I(filter_sniff , function_check):
    
    sniff(filter=filter_sniff,iface=interface_I, prn=function_check, count=1)   
    return

def sniff_A_block(filter_sniff , function_check):
    
    global count_A
    count_A=0
    #print("\nREDUNDANT A:")
    sniff(filter=filter_sniff,iface=interface_A, prn=function_check, count=NumberOfPackets)
    
    return

def sniff_B_block(filter_sniff , function_check):
    global count_B
    
    count_B=0
    #print("\nREDUNDANT B:")
    sniff(filter=filter_sniff,iface=interface_B, prn=function_check, count=NumberOfPackets)
    return
    
def sniff_I_identical_PRP(filter_sniff,function_check):

    if DEBUG_MODE: print("\nPackets received at interface_I (timeout=2 seg) :")
    sniff(filter=filter_sniff,iface=interface_I, prn=function_check, timeout=2)   
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
    
def checkPRP_tagging_A(packet):
    global count_A
    count_A=count_A+1

    bytes_I = bytes(packet_tmp1)

    bytes_A = bytes(packet)
    
    #print(packet.summary(),"\t",packet_tmp1.summary())
    
    payload = bytes_A[14:]
    RCT = payload[(len(payload)-6):]
    seqNumber, path, lsdu, suffix = get_PRP_RCT(RCT)    

    if bytes_I == bytes_A[:len(bytes_I)]:
        if DEBUG_MODE: print(">>(A) packet {} received: L2 Header and Payload OK!".format(count_A),"\t RCT-(suffix={} , LSDU size={} , LAN_ID={} , SeqNumber={})".format(hex(suffix),lsdu,hex(path),seqNumber))
    else:
        if DEBUG_MODE: print(">>(A) packet {} received: L2 Header or Payload KO.".format(count_A))

    return
 
def checkPRP_tagging_B(packet):

    global count_B
    count_B=count_B+1

    bytes_I = bytes(packet_tmp1)

    bytes_B = bytes(packet)
    
    #print(packet.summary(),"\t",packet_tmp1.summary())
    
    payload = bytes_B[14:]
    RCT = payload[(len(payload)-6):]
    seqNumber, path, lsdu, suffix = get_PRP_RCT(RCT)    

    if bytes_I == bytes_B[:len(bytes_I)]:
        if DEBUG_MODE: print(">>(B) packet {} received: L2 Header and Payload OK!".format(count_B),"\t RCT-(suffix={} , LSDU size={} , LAN_ID={} , SeqNumber={})".format(hex(suffix),lsdu,hex(path),seqNumber))
    else:
        if DEBUG_MODE: print(">>(B) packet {} received: L2 Header or Payload KO.".format(count_B))
    

    return
    
def check_PRP_untagging(packet):

    bytes_S = bytes(packet_tmp1)
    bytes_R = bytes(packet)
    
    if bytes_R == bytes_S[:len(bytes_S)-6]:
        if DEBUG_MODE: print(">>(I) packet {} received: L2 Header and Payload OK!".format(count_tmp),"\t RCT-(None)\n")
    else:
        if DEBUG_MODE: print(">>(I) packet {} received: L2 Header or Payload KO.\n".format(count_tmp))
    return
    
def check_SR(packet):

    bytes_S = bytes(packet_tmp1)
    bytes_R = bytes(packet)
    
    if bytes_R == bytes_S:
        if DEBUG_MODE: print(">>(I) packet {} received: L2 Header and Payload OK!".format(count_tmp),"\t RCT-(None)\n")
    else:
        if DEBUG_MODE: print(">>(I) packet {} received: L2 Header or Payload KO.\n".format(count_tmp))
    return    
    

#**********************************************************************************************************************************************************************************
# PRP Supervision frames:
#**********************************************************************************************************************************************************************************


def fill_ProxyTable_HPS():

    print("\n\t\t PRP Supervision frames Test\n")
    read_PRP_param()

    size_pkt =random.randint(64,1518+JumboEnabled*7500)

    mac_base = "d0:00:50:CE:00"
    offset=0

    for i in range(ProxyTableSize):

        size_pkt =random.randint(64,1518+JumboEnabled*7500)

        inc_byte = ':{:02x}'.format(i+offset)

        MAC_src_tmp = mac_base+inc_byte

        packet = Ether(src=MAC_src_tmp,dst=MAC_1,type=0xffff)/Raw(load="Hello "+''.ljust(size_pkt-18-12-20,'x')+" World")
        sendp(packet, verbose = False,iface=interface_I,count=1)  


#**********************************************************************************************************************************************************************************
# PRP TAGGING TESTS:
#**********************************************************************************************************************************************************************************

    
def PRP_tagging_1():  

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [1] PRP Tagging - Test 1\n")
    read_PRP_param()
 
    #----------------------------------------------------------------------------------------------------------------
    # Send smallest (64bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend smallest (64bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)")
    packet_tmp1 = Ether(src=MAC_1,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp1)
    if DEBUG_MODE: print("\n>(I) {} packets sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(NumberOfPackets,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))
    

    t1 = threading.Thread(target=sniff_A_block, args=("ether src "+MAC_1, checkPRP_tagging_A, ))
    t2 = threading.Thread(target=sniff_B_block, args=("ether src "+MAC_1, checkPRP_tagging_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()  
    time.sleep(0.5)

    sendp(packet_tmp1, verbose = False,iface=interface_I,count=NumberOfPackets)   
    
    t1.join()
    t2.join()
    
    packet_tmp1 = Ether(src=MAC_2,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(smallest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp1)
    if DEBUG_MODE: print("\n>(I) {} packets sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(NumberOfPackets,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))
    
    t1 = threading.Thread(target=sniff_A_block, args=("ether src "+MAC_2, checkPRP_tagging_A, ))
    t2 = threading.Thread(target=sniff_B_block, args=("ether src "+MAC_2, checkPRP_tagging_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()    
    time.sleep(0.5)

    sendp(packet_tmp1, verbose = False,iface=interface_I,count=NumberOfPackets)   
    
    t1.join()
    t2.join()  


def PRP_tagging_2():  

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [1] PRP Tagging - Test 2\n")
    read_PRP_param()    
    #----------------------------------------------------------------------------------------------------------------
    # Send biggest (1518bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)   
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend biggest (1518bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)")

    packet_tmp1 = Ether(src=MAC_1,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(biggest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp1)
    if DEBUG_MODE: print("\n>(I) {} packets sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(NumberOfPackets,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))

    t1 = threading.Thread(target=sniff_A_block, args=("ether src "+MAC_1, checkPRP_tagging_A, ))
    t2 = threading.Thread(target=sniff_B_block, args=("ether src "+MAC_1, checkPRP_tagging_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()            
    time.sleep(0.5)

    sendp(packet_tmp1, verbose = False,iface=interface_I, count=NumberOfPackets)  
                
    t1.join()
    t2.join()            
    
    packet_tmp1 = Ether(src=MAC_2,type=EtherType)/IP(len=20)/Raw(load="Hello "+''.ljust(biggest_frame-18-12-20,'x')+" World")# -12:"Hello  World"   -20:IP header   -18:L2 header
    bytes_p = bytes(packet_tmp1)
    if DEBUG_MODE: print("\n>(I) {} packets sent -(mac_dst={} , mac_src={} , ethertype={} , len_payload(inc. FCS)={})".format(NumberOfPackets,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))

    t1 = threading.Thread(target=sniff_A_block, args=("ether src "+MAC_2, checkPRP_tagging_A, ))
    t2 = threading.Thread(target=sniff_B_block, args=("ether src "+MAC_2, checkPRP_tagging_B, )) 
    t1.start()
    time.sleep(0.5)
    t2.start()            
    time.sleep(0.5)

    sendp(packet_tmp1, verbose = False,iface=interface_I, count=5)  
                
    t1.join()
    t2.join()
                                   
 
#**********************************************************************************************************************************************************************************
# PRP FORWARDING TESTS:
#**********************************************************************************************************************************************************************************


def PRP_forwarding_1():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 1\n")
    read_PRP_param()
    
    count_tmp=0
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("Send frames with correct RCT through Redundant port (A)\n")
    for i in range(NumberOfPackets):
    
        count_tmp=count_tmp+1
        
        payload = create_PRP_RCT("A")
        packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=0xffff)/Raw(load=payload)

        bytes_p = bytes(packet_tmp1)
        RCT = bytes_p[(len(bytes_p)-6):]
        seqNumber, path, lsdu, suffix = get_PRP_RCT(RCT)          
        if DEBUG_MODE: print(">(A) packet {} sent - (mac_dst={}, mac_src={}, ethertype={}, len_payload={} [suffix={}, LSDU size={}, LAN_ID={}, SeqNumber={}])".format(i+1,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:]),hex(suffix),lsdu,hex(path),seqNumber))

        t1 = threading.Thread(target=sniff_I, args=("ether src "+MAC_1, check_PRP_untagging, ))
        t1.start()
        time.sleep(0.5)
        
        sendp(packet_tmp1,count = 1 , inter = interval , verbose = False,iface=interface_A) 
               
        t1.join()
     
def PRP_forwarding_2():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 2\n")
    read_PRP_param()    

    count_tmp=0
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("Send frames with correct RCT through Redundant port (B)\n")
    for i in range(NumberOfPackets):
    
        count_tmp=count_tmp+1
        
        payload = create_PRP_RCT("B")
        packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/Raw(load=payload)
        bytes_p = bytes(packet_tmp1)
        RCT = bytes_p[(len(bytes_p)-6):]
        seqNumber, path, lsdu, suffix = get_PRP_RCT(RCT)                 
        if DEBUG_MODE: print(">(B) packet {} sent - (mac_dst={}, mac_src={}, ethertype={}, len_payload={} [suffix={}, LSDU size={}, LAN_ID={}, SeqNumber={}])".format(i+1,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:]),hex(suffix),lsdu,hex(path),seqNumber))
        
        t2 = threading.Thread(target=sniff_I, args=("ether src "+MAC_1, check_PRP_untagging, ))
        t2.start()
        time.sleep(0.5)
        
        sendp(packet_tmp1,count = 1 , inter = interval , verbose = False,iface=interface_B) 
        
        t2.join()                

def PRP_forwarding_3():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 3\n")
    read_PRP_param()  

    count_tmp=0
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("Send frames without RCT through Redundant port (A)\n")
    for i in range(NumberOfPackets):
    
        count_tmp=count_tmp+1                
        
        packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/IP(len=20)/Raw(load="Hello "+''.ljust(random.randint(smallest_frame,biggest_frame)-18-12-20,'x')+" World")
        bytes_p = bytes(packet_tmp1)              
        if DEBUG_MODE: print(">(A) packet {} sent - (mac_dst={}, mac_src={}, ethertype={}, len_payload={} )".format(i+1,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))
        
        t3 = threading.Thread(target=sniff_I, args=("ether src "+MAC_1, check_SR, ))
        t3.start()
        time.sleep(0.5)
        
        sendp(packet_tmp1,count = 1 , inter = interval , verbose = False,iface=interface_A) 
        
        t3.join()  

def PRP_forwarding_4():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 4\n")
    read_PRP_param()  

    count_tmp=0
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("Send frames without RCT through Redundant port (B)\n")
    for i in range(NumberOfPackets):
    
        count_tmp=count_tmp+1
                    
        packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/IP(len=20)/Raw(load="Hello "+''.ljust(random.randint(smallest_frame,biggest_frame)-18-12-20,'x')+" World")
        bytes_p = bytes(packet_tmp1)              
        
        if DEBUG_MODE: print(">(B) packet {} sent - (mac_dst={}, mac_src={}, ethertype={}, len_payload={} )".format(i+1,bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:])))
        
        t4 = threading.Thread(target=sniff_I, args=("ether src "+MAC_1, check_SR, ))
        t4.start()
        time.sleep(0.5)
        
        sendp(packet_tmp1,count = 1 , inter = interval , verbose = False,iface=interface_B) 
        
        t4.join()   
    
def PRP_forwarding_5():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 5\n")
    read_PRP_param()      

    count_tmp=0
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("Send identical frames with correct RCT through Redundant port (A)\n")
    payload = create_PRP_RCT("A")
    packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/Raw(load=payload)
    bytes_p = bytes(packet_tmp1)
    
    RCT = bytes_p[(len(bytes_p)-6):]
    seqNumber, path, lsdu, suffix = get_PRP_RCT(RCT)                
    
    if DEBUG_MODE: print(">(A) 2 identical packet sent - (mac_dst={}, mac_src={}, ethertype={}, len_payload={} [suffix={}, LSDU size={}, LAN_ID={}, SeqNumber={}])".format(bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:]),hex(suffix),lsdu,hex(path),seqNumber))
    
    t1 = threading.Thread(target=sniff_I_identical_PRP, args=("ether src "+MAC_1, check_PRP_untagging, ))
    t1.start()
    time.sleep(0.5)
    
    sendp(packet_tmp1,count = 2  , verbose = False,iface=interface_A) 
   
    t1.join()
   

def PRP_forwarding_6():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 6\n")
    read_PRP_param()     
   
    count_tmp=0
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend identical frames with correct RCT through Redundant port (B)\n")
    payload = create_PRP_RCT("B")
    packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/Raw(load=payload)
    bytes_p = bytes(packet_tmp1)
    
    RCT = bytes_p[(len(bytes_p)-6):]
    seqNumber, path, lsdu, suffix = get_PRP_RCT(RCT)                
    
    if DEBUG_MODE: print(">(B) 2 identical packet sent - (mac_dst={}, mac_src={}, ethertype={}, len_payload={} [suffix={}, LSDU size={}, LAN_ID={}, SeqNumber={}])".format(bytes_p[0:6],bytes_p[6:12],bytes_p[12:14],len(bytes_p[14:]),hex(suffix),lsdu,hex(path),seqNumber))
    
    t2 = threading.Thread(target=sniff_I_identical_PRP, args=("ether src "+MAC_1, check_PRP_untagging, ))
    t2.start()
    time.sleep(0.5)

    sendp(packet_tmp1,count = 2  , verbose = False,iface=interface_B) 
    
    t2.join()            
    
    
def PRP_forwarding_7():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 7\n")
    read_PRP_param()  

    SeqN_PRP=0
    payload = create_PRP_RCT("A")
    packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/Raw(load=payload) 

    SeqN_PRP=0
    payload = create_PRP_RCT("B")
    packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/Raw(load=payload)  
    
    
    delay=delay_prp
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend pairs of identical frames (but LAN ID) through A and B with increasing delay between them\n")
    #if DEBUG_MODE: print("\n\t A:")
    while(delay<0.6):
        if DEBUG_MODE: print("Delay = {}".format(delay))
        #start_time = time.time()
        t1 = threading.Thread(target=sniff_I_identical_Delay, args=("ether src "+MAC_1, Count_packets_I, ))
        t1.start() 
        time.sleep(0.5)

        sendp(packet_tmp1,count = 1 , verbose = False,iface=interface_A)
        time.sleep(delay)
        #print("--- %s seconds ---" % (time.time() - start_time))
        sendp(packet_tmp2,count = 1 , verbose = False,iface=interface_B) 
        
        t1.join()
        if DEBUG_MODE: print("\n")
        delay=delay+delay_prp

def PRP_forwarding_8():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 8\n")
    read_PRP_param()  

    SeqN_PRP=0
    payload = create_PRP_RCT("A")
    packet_tmp1 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/Raw(load=payload) 
    
    
    delay=delay_prp
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend pairs of identical frames (but LAN ID) through A with increasing delay between them\n")
    #if DEBUG_MODE: print("\n\t A:")
    while(delay<0.6):
        if DEBUG_MODE: print("Delay = {}".format(delay))
        #start_time = time.time()
        t1 = threading.Thread(target=sniff_I_identical_Delay, args=("ether src "+MAC_1, Count_packets_I, ))
        t1.start() 
        time.sleep(0.5)

        sendp(packet_tmp1,count = 1 , verbose = False,iface=interface_A)
        time.sleep(delay)
        #print("--- %s seconds ---" % (time.time() - start_time))
        sendp(packet_tmp1,count = 1 , verbose = False,iface=interface_A) 
        
        t1.join()
        if DEBUG_MODE: print("\n")
        delay=delay+delay_prp


def PRP_forwarding_9():

    global packet_tmp1, packet_tmp2, count_tmp
    global SeqN_PRP

    #print("\n\t\t [2] PRP Forwarding and Untagging - Test 9\n")
    read_PRP_param()  

    SeqN_PRP=0
    payload = create_PRP_RCT("B")
    packet_tmp2 = Ether(src=MAC_1,dst=MAC_2,type=0x0800)/Raw(load=payload)
    
    
    delay=delay_prp
    if DEBUG_MODE: print("------------------------------------------------------------------------------")
    if DEBUG_MODE: print("\nSend pairs of identical frames (but LAN ID) through B with increasing delay between them\n")
    #if DEBUG_MODE: print("\n\t A:")
    while(delay<0.6):
        if DEBUG_MODE: print("Delay = {}".format(delay))
        #start_time = time.time()
        t1 = threading.Thread(target=sniff_I_identical_Delay, args=("ether src "+MAC_1, Count_packets_I, ))
        t1.start() 
        time.sleep(0.5)

        sendp(packet_tmp2,count = 1 , verbose = False,iface=interface_B)
        time.sleep(delay)
        #print("--- %s seconds ---" % (time.time() - start_time))
        sendp(packet_tmp2,count = 1 , verbose = False,iface=interface_B) 
        
        t1.join()
        if DEBUG_MODE: print("\n")
        delay=delay+delay_prp

def PRP_tagging():
    
    ans=True
    
    while ans:
        print ("""
    #######################################
    Select test:
     [1] PRP Tagging - Test 1:
         Send smallest (64bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)

     [2] PRP Tagging - Test 2:
         Send biggest (1518bytes incl. FCS) frames with 2 different source MAC addresses through Interlink port (I)

     [e] Return to Menu
        """)
        ans=input("Select an option: ") 
        
        if ans=="1": 
            
            PRP_tagging_1()
            
        elif ans=="2":
            
            PRP_tagging_2()                  

        elif ans=="e":
            return 0
            
        elif ans !="":
            print("\n Not Valid Option Try again") 

def PRP_forwarding():
    ans=True
    
    while ans:
        print ("""
\n****************************************************************************************************************************************************************************

    Select test:

     [1] PRP Forwarding - Test 1:
         Send frames with correct RCT through Redundant port (A)

     [2] PRP Forwarding - Test 2:
         Send frames with correct RCT through Redundant port (B)

     [3] PRP Forwarding - Test 3:       
         Send frames without RCT through Redundant port (A)

     [4] PRP Forwarding - Test 4:       
         Send frames without RCT through Redundant port (B)

     [5] PRP Forwarding - Test 5:                
         Send identical frames with correct RCT through Redundant port (A)    

     [6] PRP Forwarding - Test 6:                
         Send identical frames with correct RCT through Redundant port (B)    

     [7] PRP Forwarding - Test 7:                         
         Send pairs of identical frames (but LAN ID) through A and B with increasing delay between them           

     [e] Return to Menu
        """)
        ans=input("Select an option: ") 
        
        if ans=="1": 
            
            PRP_forwarding_1()
            
        elif ans=="2":
            
            PRP_forwarding_2()      

        elif ans=="3": 
            
            PRP_forwarding_3()
            
        elif ans=="4":
            
            PRP_forwarding_4()       

        elif ans=="5":
            
            PRP_forwarding_5()      

        elif ans=="6": 
            
            PRP_forwarding_6()
            
        elif ans=="7":
            
            PRP_forwarding_7()                                         

        elif ans=="e":
            return 0
            
        elif ans !="":
            print("\n Not Valid Option Try again") 

def selectPRP_type_test():
    
    ans=True
    
    while ans:
        print ("""
    #######################################

    Select PRP type test:

     [1] PRP Tagging
     [2] PRP Forwarding and Untagging
     [e] Return to Menu
        """)
        ans=input("Select an option: ") 
        
        if ans=="1": 
            
            PRP_tagging()
            
        elif ans=="2":
            
            PRP_forwarding()                 

        elif ans=="e":
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
            
                PRP_file = sys.argv[2]                   
                fill_ProxyTable_HPS()
                exit(0)
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)      
        elif sys.argv[1].lower() == "2a".lower():

            if os.path.exists(sys.argv[2]) == True:
            
                PRP_file = sys.argv[2]                  
                PRP_tagging_1()
                exit(0)
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  

        elif sys.argv[1].lower() == "2b".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_tagging_2()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "3a".lower():
            #print("I'm here.\n\n")
            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_1()
                exit(0)                   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  

        elif sys.argv[1].lower() == "3b".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_2()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "4a".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_3()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "4b".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_4()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "5a".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_5()
                exit(0) 
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "5b".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_6()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "6".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_7()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "7".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_8()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "8".lower():

            if os.path.exists(sys.argv[2]) == True:

                PRP_file = sys.argv[2]       
                PRP_forwarding_9()
                exit(0)     
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        else:
            print("\nERROR: format of script incorrect\n")
    else:
            print("\nERROR: Number of arguments incorrect\n")


    selectPRP_type_test()
