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

#-----------------------------------------
# RSTP test - Global Variables:

RSTP_file = "RSTP_param"
count_p = 0


interface_rstp = "Ethernet"
D_rstp = 10 # (s) Duration
interval_rstp = 0.1  # (frames/s) interval



#global D_rstp, interval_rstp, ProtocolID_rstp, VersionID_rstp, BPDU_type_rstp, BPDU_flags_rstp, RootID_rstp
#global CostPath_rstp, BridgeID_rstp, PortID_rstp, MessageAge_rstp, MaxAge_rstp, HelloTime_rstp, ForwardDelay_rstp
MAC_dst_rstp="70:f8:e7:d0:ff:f1"
MAC_src_rstp="70:f8:e7:d0:ff:f1"
ethertype_rstp=0x0027
LLC_rstp=0x424203
ProtocolID_rstp = 0x0000
VersionID_rstp = 0x02
BPDU_type_rstp = 0x02
BPDU_flags_rstp = 0x0e
RootID_rstp = 0x8001001906eab880
CostPath_rstp = 0x00000000
BridgeID_rstp = 0x8001001906eab880
PortID_rstp = 0x800c
MessageAge_rstp = 0x0000
MaxAge_rstp = 0x1400
HelloTime_rstp = 0x0200
ForwardDelay_rstp = 0x0f00
VersionLength_rstp=0x00

bytes_STP_fields='\x00'

#-----------------------------------------
# Test Traffic - Global Variables:

test_file = "TestTrafficTS1"

interface_test = "Ethernet"
D_test = 1
interval_test = 1
MAC_dst_test="70:f8:e7:d0:ff:f1"
MAC_src_test="70:f8:e7:d0:ff:f1"
ethertype_test=0x0027
size_test=64



def readTestTrafficFile():
    global  interface_test, D_test, interval_test
    global MAC_dst_test, MAC_src_test, ethertype_test, payload_test

    param=list()
    with open(test_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  

    interface_test = param[0]
    D_test = int(param[1]) # (s) Duration
    interval_test = float(param[2])  # (frames/s) interval

    MAC_dst_test = param[3]
    MAC_src_test = param[4]
    ethertype_test = int(param[5],16)    
    size_test = int(param[6])

def sendTestTraffic():

    readTestTrafficFile()

    payload_test="Hello "+''.ljust(size_test-18-12-20,'x')+" World"
    packet = Ether(dst=MAC_dst_test,src=MAC_src_test,type=ethertype_test)/IP(len=20)/Raw(load=payload_test)
    #packet.show()
    c = D_test/interval_test
    
    sendp( packet, count = c, inter = interval_test, verbose = True,iface=interface_test)
    #sendp(packet,count = NumberOfPackets , inter = interval , verbose = showInfo,iface=interface) 
    pass    


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# RSTP functions:

def getByteFromInt( Int_value , index):

    #example -> Int_value = 0x424303  and index=1

    goal = 0xFF << (8 * index)

    shift_byte = Int_value & goal   # 0x4300

    byte_ = shift_byte >> (8 * index) # 0x43

    return byte_

def getLLCfields(LLC_value):

    dsap = getByteFromInt(LLC_value , 2)
    ssap = getByteFromInt(LLC_value , 1)
    ctrl = getByteFromInt(LLC_value , 0)

    return dsap, ssap, ctrl
def toHex(x):

    a = " ".join("{:02x}".format(x[i]) for i in range(len(x)))
    return a

def showRSTPfields():

    print("""

    General config:
        Interface                       ={}
        Duration (s)                    ={}
        rate (frames/s)                 ={}
    
    L2 header:
        MAC_dst                         ={}
        MAC_src                         ={}
        Ethertype                       ={}
    LLC                                 ={}
    """.format(interface_rstp,D_rstp,interval_rstp,MAC_dst_rstp,MAC_src_rstp,ethertype_rstp,hex(LLC_rstp)))

    print("""
    RSTP fields:
        Protocol Identifier             ={}
        Protocol Version Identifier     ={}
        BPDU type                       ={}
        BPDU flags                      ={}
        Root Identifier                 ={}
        Root Path cost                  ={}
        Bridge Identifier               ={}
        Port Identifier                 ={}
        Message age                     ={}
        Max age                         ={}
        Hello time                      ={}
        Forward delay                   ={}

    """.format(toHex(bytes_STP_fields[0:2]),toHex(bytes_STP_fields[2:3]),toHex(bytes_STP_fields[3:4]),toHex(bytes_STP_fields[4:5]),toHex(bytes_STP_fields[5:13]),toHex(bytes_STP_fields[13:17]),toHex(bytes_STP_fields[17:25]),toHex(bytes_STP_fields[25:27]),toHex(bytes_STP_fields[27:29]),toHex(bytes_STP_fields[29:31]),toHex(bytes_STP_fields[31:33]),toHex(bytes_STP_fields[33:35])))

def read_RSTP_param():
    global  interface_rstp, D_rstp, interval_rstp
    global MAC_dst_rstp, MAC_src_rstp, ethertype_rstp, LLC_rstp, ProtocolID_rstp, VersionID_rstp, BPDU_type_rstp, BPDU_flags_rstp, RootID_rstp
    global CostPath_rstp, BridgeID_rstp, PortID_rstp, MessageAge_rstp, MaxAge_rstp, HelloTime_rstp, ForwardDelay_rstp, VersionLength_rstp

    param=list()
    with open(RSTP_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  


    interface_rstp = param[0]
    D_rstp = int(param[1]) # (s) Duration
    interval_rstp = float(param[2])  # (frames/s) interval

    MAC_dst_rstp = param[3]
    MAC_src_rstp = param[4]
    ethertype_rstp = int(param[5],16)
    LLC_rstp = int(param[6],16)
    ProtocolID_rstp = int(param[7],16)
    VersionID_rstp = int(param[8],16)
    BPDU_type_rstp = int(param[9],16)
    
    tmp_BPDU_flags_rstp = param[10]
    BPDU_flags_rstp=int(tmp_BPDU_flags_rstp.replace("-",""),2)
    
    tmp_RootID_rstp = param[11]
    rootid, rootmac = tmp_RootID_rstp.split('-')
    RootID_rstp = int(rootid+rootmac.replace(":",""),16)

    
    CostPath_rstp = int(param[12],16)
    
    tmp_BridgeID_rstp = param[13]
    bridgeid, bridgemac = tmp_BridgeID_rstp.split('-')    
    BridgeID_rstp = int(bridgeid+bridgemac.replace(":",""),16)
    
    PortID_rstp = int(param[14],16)
    MessageAge_rstp = int(param[15],16)
    MaxAge_rstp = int(param[16],16)
    HelloTime_rstp = int(param[17],16)
    ForwardDelay_rstp = int(param[18],16)
    VersionLength_rstp = int(param[19],16)
    
    bytes_STP_fields = struct.pack('>HBBBQIQHHHHHB',ProtocolID_rstp,VersionID_rstp,BPDU_type_rstp,BPDU_flags_rstp,RootID_rstp,CostPath_rstp,BridgeID_rstp,PortID_rstp,MessageAge_rstp,MaxAge_rstp,HelloTime_rstp,ForwardDelay_rstp,VersionLength_rstp)
    
    padding = struct.pack('>IHB',0,0,0)

    bytes_STP_fields = bytes_STP_fields + padding

    return bytes_STP_fields
    
'''
struct pack/unpack identificadores:
Format  C type          Python type     Size  
--------------------------------------------
c       char            string(1)       1
b       signed char     integer         1
B       unsigned char   integer         1
?       _Bool           bool            1
h       short           integer         2
H       U short         integer         2
i       int             integer         4
I       U int           integer         4
l       long            integer         4
L       U long          integer         4
q       long long       integer         8
Q       U long long     integer         8
f       float           float           4
d       double          float           8
s       char[]          string
p       char[]          string
P       void *          integer

'''    
    

def sendBPDUs():

    global bytes_STP_fields

    bytes_STP_fields = read_RSTP_param()

    showRSTPfields()

    dsap_rstp , ssap_rstp , ctrl_rstp = getLLCfields(LLC_rstp)

    packet = Ether(dst=MAC_dst_rstp,src=MAC_src_rstp,type=ethertype_rstp)/LLC(dsap=dsap_rstp ,ssap=ssap_rstp ,ctrl=ctrl_rstp )/STP(bytes_STP_fields)
    
    c = D_rstp/interval_rstp
    
    sendp( packet, count = c, inter = interval_rstp, verbose = True,iface=interface_rstp)
    #sendp(packet,count = NumberOfPackets , inter = interval , verbose = showInfo,iface=interface) 
    pass
  
def mac_to_int(mac):
    res = re.match('^((?:(?:[0-9a-f]{2}):){5}[0-9a-f]{2})$', mac.lower())
    if res is None:
        raise ValueError('invalid mac address')
    return int(res.group(0).replace(':', ''), 16)

def Root_Bridge_IDformat(priority_int , mac_str):
    
    mac_int = mac_to_int(mac_str)
    
    bytes_prior = struct.pack('>H',priority_int) #2 Bytes
    
    bytes_mac = struct.pack('>Q',mac_int)  #Q=8 Bytes, but mac=6B -> 00 00 MAC
    int_mac = int.from_bytes(bytes_mac, byteorder='big')<<16 # int value -> MAC 00 00
    bytes_mac = struct.pack('>Q',int_mac) # byte value -> MAC 00 00
    
    bytes_bridgeID = bytes_prior+bytes_mac  # 10 Bytes -> Priority(2)-MAC(6)-00(1)-00(1)
    int_bridgeID = int.from_bytes(bytes_bridgeID, byteorder='big')>>16  # int value, 8 Bytes -> Priority(2)-MAC(6)
    
    return int_bridgeID

  
def check_BPDU(packet):
    
    global count_p
    
    count_p=count_p+1
    
    bytes_STP_fields = read_RSTP_param()
    
    #packet.show()
    bytes_packet = bytes(packet)
    bytes_STP=bytes_packet[17:53]
    
    
    proto = bytes_STP[0:2]
    version = bytes_STP[2:3]
    bpdutype = bytes_STP[3:4]
    bpduflags = bytes_STP[4:5]
    rootid = bytes_STP[5:13]
    pathcost = bytes_STP[13:17]
    bridgeid = bytes_STP[17:25]
    portid = bytes_STP[25:27]
    age = bytes_STP[27:29]
    maxage = bytes_STP[29:31]
    hellotime = bytes_STP[31:33]
    fwddelay = bytes_STP[33:35]

    #print(bridgeid)
    #print(bridgemac)
    
    
    KO_fields=list()
    print("\n****Packet {}:****".format(count_p))
    print(" KO fields:")
    if int.from_bytes(proto,byteorder='big') != ProtocolID_rstp:
        KO_fields.append("Protocol ID")
        print("Protocol ID: "+str(hex(ProtocolID_rstp))+"  != Received: "+str(proto))
        
    if int.from_bytes(version,byteorder='big') != VersionID_rstp:
        KO_fields.append("Version ID")
        print("Version ID: "+str(hex(VersionID_rstp))+"  != Received: "+str(version))
        
    if int.from_bytes(bpdutype,byteorder='big') != BPDU_type_rstp:
        KO_fields.append("BPDU Type")
        print("BPDU type: "+str(hex(BPDU_type_rstp))+"  != Received: "+str(bpdutype))
        
    if int.from_bytes(bpduflags,byteorder='big') != BPDU_flags_rstp:
        KO_fields.append("BPDU Flags")
        print("BPDU flags: "+str(hex(BPDU_flags_rstp))+"  != Received: "+str(bpduflags))
        
    if int.from_bytes(rootid,byteorder='big') != RootID_rstp:
        KO_fields.append("Root ID")
        print("Root ID: "+str(hex(RootID_rstp))+"  != Received: "+str(rootid))
        
    if int.from_bytes(pathcost,byteorder='big') != CostPath_rstp:
        KO_fields.append("Cost Path")
        print("Path cost: "+str(hex(CostPath_rstp))+"  != Received: "+str(pathcost))       

    if int.from_bytes(bridgeid,byteorder='big') != BridgeID_rstp:
        KO_fields.append("Bridge ID")
        print("Bridge ID: "+str(hex(BridgeID_rstp))+"  != Received: "+str(bridgeid))

    if int.from_bytes(portid,byteorder='big') != PortID_rstp:
        KO_fields.append("Port ID")  
        print("Port ID: "+str(hex(PortID_rstp))+"  != Received: "+str(portid))         
        
    if int.from_bytes(age,byteorder='big') != MessageAge_rstp:
        KO_fields.append("Message Age")
        print("Message Age: "+str(hex(MessageAge_rstp))+"  != Received: "+str(age))  

    if int.from_bytes(maxage,byteorder='big') != MaxAge_rstp:
        KO_fields.append("Max Age")
        print("Max Age: "+str(hex(MaxAge_rstp))+"  != Received: "+str(maxage))
        
    if int.from_bytes(hellotime,byteorder='big') != HelloTime_rstp:
        KO_fields.append("Hello Time")
        print("Hello Time: "+str(hex(HelloTime_rstp))+"  != Received: "+str(hellotime))

    if int.from_bytes(fwddelay,byteorder='big') != ForwardDelay_rstp:
        KO_fields.append("Forward Delay")
        print("Forward Delay: "+str(hex(ForwardDelay_rstp))+"  != Received: "+str(fwddelay))         
        
    if len(KO_fields) == 0:

        print("0\n Packet {} OK!\n".format(count_p))    
    
    # Print this information
    #print("Layer: ", layer, " Field: ", field, " Value: ", field_value)
    
    
def RSTP_TS_2():
    global count_p
    
    count_p=0
    
    print("waiting for a RSTP-BPDU frames... (Press CTRL+C to Stop)")
    packet=sniff(filter="ether proto 0x8870",iface=interface_rstp, prn=check_BPDU, store=0)    


def selectTest():
    ans=True
    while ans:
        print ("""
#######################################
MENU:
 [9] RSTP-TS-1 
 [10] RSTP-TS-2 
 [e] Exit
        """)
        ans=input("Select an option: ") 
        
        if ans=="9":
            print("""\n 
************************************************************************
        [9] RSTP-TS-1 """) 
            
            sendBPDUs()
        
        elif ans=="10":
            print("""\n 
************************************************************************
        [10] RSTP-TS-2 """)
            RSTP_TS_2()
        elif ans=="e":
            print("\n Exit") 
            exit(0)
        elif ans !="":
            print("\n Not Valid Option Try again")     

#***************************************************************************************************************
# Main:
#***************************************************************************************************************

if __name__ == '__main__':

    
    if len(sys.argv) == 3:
    
        if sys.argv[1].lower() == "-t".lower():

            if os.path.exists(sys.argv[2]) == True:
            
                RSTP_file = sys.argv[2]                   
                sendBPDUs()
                exit(0)
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "-test".lower():

            if os.path.exists(sys.argv[2]) == True:
            
                test_file = sys.argv[2]                   
                sendTestTraffic()
                exit(0)
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)                  
        elif sys.argv[1].lower() == "rstp_ts_2".lower():

            if os.path.exists(sys.argv[2]) == True:

                RSTP_file = sys.argv[2]        
                RSTP_TS_2()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
  
        else:
            print("\nERROR: format of script incorrect\n")
    else:
            print("\nERROR: Number of arguments incorrect\n")


    selectTest()

