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
DEBUG_MODE = True

packet_tmp1 = Ether()/IP()
packet_tmp2 = Ether()/IP()

count_I=0
count_A = 0
count_B = 0
count_tmp = 0



#-----------------------------------------
# EDSA test - Global Variables:

EDSA_file = "EDSA_param"
EDSA_tag_file = "EDSA_tag_param"

#global interface_edsa, MAC_dst_edsa, position_N, value_X, ethtype_edsa
#global mac_dst_edsatag, mac_src_edsatag, dst_port_edsatag, ethtype_edsatag, payload_edsatag

interface_edsa = "Ethernet"
MAC_dst_edsa = "DC:A6:32:47:4E:18"
position_N = 3
value_X = 0x5C
ethtype_edsa = 0x0800

interface_edsatag = "Ethernet"
mac_dst_edsatag = "DC:A6:32:47:4E:18"
mac_src_edsatag = "2C:F0:5D:25:8A:B5"
dst_port_edsatag = 5
ethtype_edsatag = 0x9100
payload_edsatag = "Hello World"


def bytes2int(value_bytes):

    value_int = int.from_bytes(value_bytes,"big")
    
    return value_int
    
def getMAC_str():

    # to get physical address:
    original_mac_address = getnode()

    #convert raw format into hex format
    hex_mac_address = str(":".join(re.findall('..', '%012x' % original_mac_address)))
       
    return hex_mac_address

def toHex(x):

    a = " ".join("{:02x}".format(x[i]) for i in range(len(x)))
    return a

#***************************************************************************************************************
# Test Functions:
#***************************************************************************************************************

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# EDSA functions:

def read_EDSA_param():

    global interface_edsa, MAC_dst_edsa, position_N, value_X, ethtype_edsa
    param=list()
    with open(EDSA_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  

    interface_edsa = param[0]
    MAC_dst_edsa = param[1]
    position_N = int(param[2])
    value_X = int(param[3],16)
    ethtype_edsa = int(param[4],16)
    
def read_EDSA_tag_param():

    global interface_edsatag, mac_dst_edsatag, mac_src_edsatag, dst_port_edsatag, ethtype_edsatag, payload_edsatag
    param=list()
    with open(EDSA_tag_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  

    interface_edsatag = param[0]
    mac_dst_edsatag = param[1]
    mac_src_edsatag = param[2]
    dst_port_edsatag = format(int(param[3]), 'b').zfill(10) # convert int value to binary string (10 bits)
    ethtype_edsatag = int(param[4],16)
    payload_edsatag = param[5]

def EDSA_tag_CPU_TS():

    read_EDSA_tag_param()

    LSB_5 = dst_port_edsatag[:5]
    MSB_5 = dst_port_edsatag[5:10]

    byte5 = int('010'+LSB_5,2)
    byte6 = int(MSB_5+'000',2)

    bytes_DSA = struct.pack('>BBBB',0xDC,0xDC,0x00,0x00) + struct.pack('>B',byte5) + struct.pack('>B',byte6) +struct.pack('>BB',0x00,0x00)

    bytes_format = bytes.fromhex(mac_dst_edsatag.replace(':','')) + bytes.fromhex(mac_src_edsatag.replace(':','')) + bytes_DSA + struct.pack('>H',ethtype_edsatag)

    for i in range(10):
        payload="Hello "+''.ljust(random.randint(64,1518)-18-12-20,'x')+" World"
        p=Raw(load=bytes_format+payload.encode())
        sendp(p, count = 1, iface = interface_edsatag)

def EDSA_CPU_DUT():

    read_EDSA_param()
    
    #payload = str.encode(''.ljust(position_N-1,'x'))+value_X.to_bytes(2, byteorder='big')+str.encode(''.ljust(position_N-1,'x'))
    
    value = struct.pack('>B',value_X)
    
    payload = str.encode(''.ljust(position_N,'-'))+value+str.encode(''.ljust(position_N,'-'))+str.encode(".........................................")
    
    packet = Ether(src=MAC_dst_edsa,dst="00:0D:0D:0D:0D:0D", type = ethtype_edsa)/Raw(load=payload)
    #packet = Ether(src=MAC_dst_edsa,dst="01:80:c2:00:00:00", type = ethtype_edsa)/Raw(load=payload)
    bytes_packet=bytes(packet)
    print("\n{}: {}".format(len(bytes_packet),toHex(bytes_packet)))
    sendp(packet,count = 10, verbose = True,iface=interface_edsa)    


def check_EDSA(packet):

    read_EDSA_param()

    payload=getattr(packet["Raw"],"load")
    value_r=payload[position_N]
    
    if payload[position_N] == value_X:
        print("Test OK!")
    else:
        print("Test KO:\nvalue: "+str(hex(value_X))+"  -> Received: "+hex(value_r)+"\n")
    
    #print(payload[position_N])
    #print(type(payload))

    #packet.show()

def EDSA_CPU_TS():

    print("waiting for a EDSA frames... (Press CTRL+C to Stop)")
    packet=sniff(filter="ether src DC:A6:32:47:4E:18 and ether proto 0x9100",iface=interface_edsa, prn=check_EDSA, store=0)        


#***************************************************************************************************************
# Main:
#***************************************************************************************************************

if __name__ == '__main__':

    #global param, RSTP_file, IGMP_file, EDSA_file 

    if len(sys.argv) == 3:
    
        if sys.argv[1] == "-t":
            
            if os.path.exists(sys.argv[2]) == True:
            
                EDSA_file = sys.argv[2]
            
#                 print("""\n 
# ************************************************************************
#         [3] EDSA Tagging from CPU-TS """)             
                EDSA_tag_CPU_TS()
                exit(0)
            else:
                print("\nERROR: File doesn't exist\n")
                exit(0)
        
        elif sys.argv[1] == "4":
            if os.path.exists(sys.argv[2]) == True:
            
                EDSA_file = sys.argv[2]
            
#                 print("""\n 
# ************************************************************************
#         [4] EDSA Driver from CPU-DUT """)             
                EDSA_CPU_DUT()
                exit(0)
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)       
    
        elif sys.argv[1] == "5":
            if os.path.exists(sys.argv[2]) == True:
            
                EDSA_file = sys.argv[2]
            
#                 print("""\n 
# ************************************************************************
#         [5] EDSA Driver from CPU-TS """)             
                EDSA_CPU_TS()
                exit(0)
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)          
                  
        else:
            pass
    else:
        
        print("\nNumber of arguments incorrect\n")

    ans=True
    while ans:
        print ("""
#######################################
MENU:
 [3] EDSA Tagging from CPU-TS
 [4] EDSA Driver from CPU-DUT
 [5] EDSA Driver from CPU-TS
 [e] Exit
        """)
        ans=input("Select an option: ") 
        
        if ans=="3":
            print("""\n 
************************************************************************
        [3] EDSA Tagging from CPU-TS """)  
        
            EDSA_tag_CPU_TS()
        
        elif ans=="4":
            print("""\n 
************************************************************************
        [4] EDSA Driver from CPU-DUT """) 
            
            EDSA_CPU_DUT()
        
        elif ans=="5":
            print("""\n 
************************************************************************
        [5] EDSA Driver from CPU-TS """)
            EDSA_CPU_TS()

        elif ans=="e":
            print("\n Exit") 
            exit(0)
        elif ans !="":
            print("\n Not Valid Option Try again") 


