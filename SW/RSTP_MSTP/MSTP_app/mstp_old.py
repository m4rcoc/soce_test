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
# MSTP test - Global Variables:

MSTP_file = "MSTP_param"
count_p = 0

#global D_mstp, interval_mstp, ProtocolID_mstp, VersionID_mstp, BPDU_type_mstp, BPDU_flags_mstp, RootID_mstp
#global CostPath_mstp, BridgeID_mstp, PortID_mstp, MessageAge_mstp, MaxAge_mstp, HelloTime_mstp, ForwardDelay_mstp
interface_mstp = "Ethernet"
D_mstp = 10 # (s) Duration
interval_mstp = 0.1  # (frames/s) interval
ProtocolID_mstp = 0x0000
VersionID_mstp = 0x02
BPDU_type_mstp = 0x02
BPDU_flags_mstp = 0x0e
RootID_mstp = 0x8001001906eab880
CostPath_mstp = 0x00000000
BridgeID_mstp = 0x8001001906eab880
PortID_mstp = 0x800c
MessageAge_mstp = 0x0000
MaxAge_mstp = 0x1400
HelloTime_mstp = 0x0200
ForwardDelay_mstp = 0x0f00

bytes_STP_fields='\x00'
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# MSTP functions:


def showMSTPfields():

    print("""
    
    MSTP fields:
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
        Version 1 Length                ={}
        Version 3 Length                ={}
        MST Config ID                   ={}
        MST Config name                 ={}
        MST Config revision             ={}
        MST Config digest               ={}
        CIST Bridge Root Path Cost      ={}
        CIST Bridge Identifier          ={}
        CIST Remaining hops             ={}
    """.format(bytes_STP_fields[0:2],bytes_STP_fields[2:3],bytes_STP_fields[3:4],bytes_STP_fields[4:5],bytes_STP_fields[5:13],bytes_STP_fields[13:17],bytes_STP_fields[17:25],bytes_STP_fields[25:27],bytes_STP_fields[27:29],bytes_STP_fields[29:31],bytes_STP_fields[31:33],bytes_STP_fields[33:35]))

def read_MSTP_param():
    global MAC_dst_mstp, interface_mstp, D_mstp, interval_mstp, ProtocolID_mstp, VersionID_mstp, BPDU_type_mstp, BPDU_flags_mstp, RootID_mstp
    global CostPath_mstp, BridgeID_mstp, PortID_mstp, MessageAge_mstp, MaxAge_mstp, HelloTime_mstp, ForwardDelay_mstp
    
    param=list()
    with open(MSTP_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  

    MAC_dst_mstp = param[0]
    interface_mstp = param[1]
    D_mstp = int(param[2]) # (s) Duration
    interval_mstp = float(param[3])  # (frames/s) interval
    ProtocolID_mstp = int(param[4],16)
    VersionID_mstp = int(param[5],16)
    BPDU_type_mstp = int(param[6],16)
    
    tmp_BPDU_flags_mstp = param[7]
    BPDU_flags_mstp=int(tmp_BPDU_flags_mstp.replace("-",""),2)
    
    tmp_RootID_mstp = param[8]
    rootid, rootmac = tmp_RootID_mstp.split('-')
    RootID_mstp = int(rootid+rootmac.replace(":",""),16)

    
    CostPath_mstp = int(param[9],16)
    
    tmp_BridgeID_mstp = param[10]
    bridgeid, bridgemac = tmp_BridgeID_mstp.split('-')    
    BridgeID_mstp = int(bridgeid+bridgemac.replace(":",""),16)
    
    PortID_mstp = int(param[11],16)
    MessageAge_mstp = int(param[12],16)
    MaxAge_mstp = int(param[13],16)
    HelloTime_mstp = int(param[14],16)
    ForwardDelay_mstp = int(param[15],16)
    Version_1_Length = int(param[16],16)
    Version_3_Length = int(param[17],16)

    MTS_ConfigIDFormatSelector = param[18]
    MTS_ConfigName = param[19]
    MTS_RevisionLevel = int(param[20],16)
    MTS_ConfigDigest = param[21]
    CIST_InternalRootPathCost = int(param[22],16)

    tmp_CIST_BridgeID_mstp = param[8]
    rootid, rootmac = tmp_CIST_BridgeID_mstp.split('-')
    CIST_BridgeIdentifier = int(rootid+rootmac.replace(":",""),16) 

    CIST_RemainingHops = int(param[24],16)

    bytes_STP_fields = struct.pack('>HBBBQIQHHHHHBH',ProtocolID_mstp,VersionID_mstp,BPDU_type_mstp,BPDU_flags_mstp,RootID_mstp,CostPath_mstp,BridgeID_mstp,PortID_mstp,MessageAge_mstp,MaxAge_mstp,HelloTime_mstp,ForwardDelay_mstp,Version_1_Length,Version_3_Length)
    bytes_STP_fields = bytes_STP_fields + struct.pack('>BsH',MTS_ConfigIDFormatSelector,MTS_ConfigName,MTS_RevisionLevel) + struct.pack('>Q',int(MTS_ConfigDigest[2:18],16)) + struct.pack('>Q',int(MTS_ConfigDigest[18:34],16)) + struct.pack('>IQB',CIST_InternalRootPathCost,CIST_BridgeIdentifier,CIST_RemainingHops)

    number_of_mstids = int(param[25])

    for i in range(number_of_mstids):
        locals()["MSTI_flags_"+str(i+1)] = int(param[26+6*i],16)
        locals()["MSTI_ID_Pri_RegionalRoot"+str(i+1)] = int(param[27+6*i],16)
        locals()["MSTI_InternalRootPathCost_"+str(i+1)] = int(param[28+6*i],16)
        locals()["MSTI_BridgeIdentifierPriority_"+str(i+1)] = int(param[29+6*i],16)
        locals()["MSTI_PortIdentifierPriority_"+str(i+1)] = int(param[30+6*i],16)
        locals()["MSTI_RemainingHops_"+str(i+1)] = int(param[31+6*i],16)

        locals()["bytes_MSTID_"+str(i+1)] = struct.pack('>BQIBBB',locals()["MSTI_flags_"+str(i+1)],locals()["MSTI_ID_Pri_RegionalRoot"+str(i+1)],locals()["MSTI_InternalRootPathCost_"+str(i+1)],locals()["MSTI_BridgeIdentifierPriority_"+str(i+1),locals()["MSTI_PortIdentifierPriority_"+str(i+1)],locals()["MSTI_RemainingHops_"+str(i+1)])
    
        bytes_STP_fields = bytes_STP_fields + locals()["bytes_MSTID_"+str(i+1)]

    
    
    
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


def MSTP_TS_1():

    global bytes_STP_fields

    bytes_STP_fields = read_MSTP_param()

    showMSTPfields()

    packet = Ether(dst=MAC_dst_mstp)/LLC()/STP(bytes_STP_fields)
    
    c = D_mstp/interval_mstp
    
    sendp( packet, count = c, inter = interval_mstp, verbose = True,iface=interface_mstp)
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
    
    bytes_STP_fields = read_MSTP_param()
    
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
    if int.from_bytes(proto,byteorder='big') != ProtocolID_mstp:
        KO_fields.append("Protocol ID")
        print("Protocol ID: "+str(hex(ProtocolID_mstp))+"  != Received: "+str(proto))
        
    if int.from_bytes(version,byteorder='big') != VersionID_mstp:
        KO_fields.append("Version ID")
        print("Version ID: "+str(hex(VersionID_mstp))+"  != Received: "+str(version))
        
    if int.from_bytes(bpdutype,byteorder='big') != BPDU_type_mstp:
        KO_fields.append("BPDU Type")
        print("BPDU type: "+str(hex(BPDU_type_mstp))+"  != Received: "+str(bpdutype))
        
    if int.from_bytes(bpduflags,byteorder='big') != BPDU_flags_mstp:
        KO_fields.append("BPDU Flags")
        print("BPDU flags: "+str(hex(BPDU_flags_mstp))+"  != Received: "+str(bpduflags))
        
    if int.from_bytes(rootid,byteorder='big') != RootID_mstp:
        KO_fields.append("Root ID")
        print("Root ID: "+str(hex(RootID_mstp))+"  != Received: "+str(rootid))
        
    if int.from_bytes(pathcost,byteorder='big') != CostPath_mstp:
        KO_fields.append("Cost Path")
        print("Path cost: "+str(hex(CostPath_mstp))+"  != Received: "+str(pathcost))       

    if int.from_bytes(bridgeid,byteorder='big') != BridgeID_mstp:
        KO_fields.append("Bridge ID")
        print("Bridge ID: "+str(hex(BridgeID_mstp))+"  != Received: "+str(bridgeid))

    if int.from_bytes(portid,byteorder='big') != PortID_mstp:
        KO_fields.append("Port ID")  
        print("Port ID: "+str(hex(PortID_mstp))+"  != Received: "+str(portid))         
        
    if int.from_bytes(age,byteorder='big') != MessageAge_mstp:
        KO_fields.append("Message Age")
        print("Message Age: "+str(hex(MessageAge_mstp))+"  != Received: "+str(age))  

    if int.from_bytes(maxage,byteorder='big') != MaxAge_mstp:
        KO_fields.append("Max Age")
        print("Max Age: "+str(hex(MaxAge_mstp))+"  != Received: "+str(maxage))
        
    if int.from_bytes(hellotime,byteorder='big') != HelloTime_mstp:
        KO_fields.append("Hello Time")
        print("Hello Time: "+str(hex(HelloTime_mstp))+"  != Received: "+str(hellotime))

    if int.from_bytes(fwddelay,byteorder='big') != ForwardDelay_mstp:
        KO_fields.append("Forward Delay")
        print("Forward Delay: "+str(hex(ForwardDelay_mstp))+"  != Received: "+str(fwddelay))         
        
    if len(KO_fields) == 0:

        print("0\n Packet {} OK!\n".format(count_p))    
    
    # Print this information
    #print("Layer: ", layer, " Field: ", field, " Value: ", field_value)
    
    
def MSTP_TS_2():
    global count_p
    
    count_p=0
    
    print("waiting for a MSTP-BPDU frames... (Press CTRL+C to Stop)")
    packet=sniff(filter="ether proto 0x8870",iface=interface_mstp, prn=check_BPDU, store=0)    


def selectTest():
    ans=True
    while ans:
        print ("""
#######################################
MENU:
 [9] MSTP-TS-1 
 [10] MSTP-TS-2 
 [e] Exit
        """)
        ans=input("Select an option: ") 
        
        if ans=="9":
            print("""\n 
************************************************************************
        [9] MSTP-TS-1 """) 
            
            MSTP_TS_1()
        
        elif ans=="10":
            print("""\n 
************************************************************************
        [10] MSTP-TS-2 """)
            MSTP_TS_2()
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
    
        if sys.argv[1].lower() == "mstp_ts_1".lower():

            if os.path.exists(sys.argv[2]) == True:
            
                MSTP_file = sys.argv[2]                   
                MSTP_TS_1()
                exit(0)
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
        elif sys.argv[1].lower() == "mstp_ts_2".lower():

            if os.path.exists(sys.argv[2]) == True:

                MSTP_file = sys.argv[2]        
                MSTP_TS_2()
                exit(0)   
            else:
                print("\nERROR: File doesn't exist\n")   
                exit(0)  
  
        else:
            print("\nERROR: format of script incorrect\n")
    else:
            print("\nERROR: Number of arguments incorrect\n")


    selectTest()

