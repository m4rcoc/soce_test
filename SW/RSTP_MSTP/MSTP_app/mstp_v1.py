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

vlan_enabled="False"
vlan_tag=0
interface_mstp = "Ethernet"
D_mstp = 10 # (s) Duration
interval_mstp = 0.1  # (frames/s) interval



#global D_mstp, interval_mstp, ProtocolID_mstp, VersionID_mstp, BPDU_type_mstp, BPDU_flags_mstp, RootID_mstp
#global CostPath_mstp, BridgeID_mstp, PortID_mstp, MessageAge_mstp, MaxAge_mstp, HelloTime_mstp, ForwardDelay_mstp
MAC_dst_mstp="70:f8:e7:d0:ff:f1"
MAC_src_mstp="70:f8:e7:d0:ff:f1"
ethertype_mstp=0x0027
LLC_mstp=0x424203
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
Version_1_Length=0x00

Version_3_Length=0x0040

number_of_mstids=0

MTS_ConfigIDFormatSelector=0
MTS_ConfigName=0
MTS_RevisionLevel=0
MTS_ConfigDigest=0
CIST_InternalRootPathCost=0
CIST_BridgeIdentifier=0
CIST_RemainingHops=0




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
    print(interface_test)
    sendp( packet, count = c, inter = interval_test, verbose = True,iface=interface_test)
    #sendp(packet,count = NumberOfPackets , inter = interval , verbose = showInfo,iface=interface) 
    pass    


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# MSTP functions:

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

def showMSTPfields():

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
    """.format(interface_mstp,D_mstp,interval_mstp,MAC_dst_mstp,MAC_src_mstp,ethertype_mstp,hex(LLC_mstp)))

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
        Version_1_Length                ={}
        Version_3_Length                ={}

    """.format(toHex(bytes_STP_fields[0:2]),toHex(bytes_STP_fields[2:3]),toHex(bytes_STP_fields[3:4]),toHex(bytes_STP_fields[4:5]),toHex(bytes_STP_fields[5:13]),toHex(bytes_STP_fields[13:17]),toHex(bytes_STP_fields[17:25]),toHex(bytes_STP_fields[25:27]),toHex(bytes_STP_fields[27:29]),toHex(bytes_STP_fields[29:31]),toHex(bytes_STP_fields[31:33]),toHex(bytes_STP_fields[33:35]),toHex(bytes_STP_fields[35:36]),toHex(bytes_STP_fields[36:38])))

def read_MSTP_param():
    global  interface_mstp, D_mstp, interval_mstp
    global MAC_dst_mstp, MAC_src_mstp, ethertype_mstp, LLC_mstp, ProtocolID_mstp, VersionID_mstp, BPDU_type_mstp, BPDU_flags_mstp, RootID_mstp
    global CostPath_mstp, BridgeID_mstp, PortID_mstp, MessageAge_mstp, MaxAge_mstp, HelloTime_mstp, ForwardDelay_mstp, Version_1_Length
    global Version_3_Length, MTS_ConfigIDFormatSelector, MTS_ConfigName, MTS_RevisionLevel, MTS_ConfigDigest, CIST_InternalRootPathCost, CIST_BridgeIdentifier, CIST_RemainingHops
    global number_of_mstids

    param=list()
    with open(MSTP_file, 'r') as infile:

        for line in infile:
            if line.find('=')!=-1:
                tmp=line.split('=')
                param.append(tmp[1][:-1])  


    interface_mstp = param[0]
    D_mstp = int(param[1]) # (s) Duration
    interval_mstp = float(param[2])  # (frames/s) interval

    MAC_dst_mstp = param[3]
    MAC_src_mstp = param[4]
    ethertype_mstp = int(param[5],16)
    LLC_mstp = int(param[6],16)
    ProtocolID_mstp = int(param[7],16)
    VersionID_mstp = int(param[8],16)
    BPDU_type_mstp = int(param[9],16)
    
    tmp_BPDU_flags_mstp = param[10]
    BPDU_flags_mstp=int(tmp_BPDU_flags_mstp.replace("-",""),2)
    
    tmp_RootID_mstp = param[11]
    rootid, rootmac = tmp_RootID_mstp.split('-')
    RootID_mstp = int(rootid+rootmac.replace(":",""),16)

    
    CostPath_mstp = int(param[12],16)
    
    tmp_BridgeID_mstp = param[13]
    bridgeid, bridgemac = tmp_BridgeID_mstp.split('-')    
    BridgeID_mstp = int(bridgeid+bridgemac.replace(":",""),16)
    
    PortID_mstp = int(param[14],16)
    MessageAge_mstp = int(param[15],16)
    MaxAge_mstp = int(param[16],16)
    HelloTime_mstp = int(param[17],16)
    ForwardDelay_mstp = int(param[18],16)
    Version_1_Length = int(param[19],16)

    Version_3_Length = int(param[20],16)
    

    MTS_ConfigIDFormatSelector = int(param[21],16)
    MTS_ConfigName = param[22]
    MTS_RevisionLevel = int(param[23],16)
    MTS_ConfigDigest = param[24]
    CIST_InternalRootPathCost = int(param[25],16)

    tmp_CIST_BridgeID_mstp = param[26]
    rootid, rootmac = tmp_CIST_BridgeID_mstp.split('-')
    CIST_BridgeIdentifier = int(rootid+rootmac.replace(":",""),16) 

    CIST_RemainingHops = int(param[27],16)

    bytes_config_name = struct.pack('>QQQQ',int(MTS_ConfigName[2:18],16),int(MTS_ConfigName[18:34],16),int(MTS_ConfigName[34:50],16),int(MTS_ConfigName[50:66],16))

    bytes_STP_fields = struct.pack('>HBBBQIQHHHHHBH',ProtocolID_mstp,VersionID_mstp,BPDU_type_mstp,BPDU_flags_mstp,RootID_mstp,CostPath_mstp,BridgeID_mstp,PortID_mstp,MessageAge_mstp,MaxAge_mstp,HelloTime_mstp,ForwardDelay_mstp,Version_1_Length,Version_3_Length)
    bytes_STP_fields = bytes_STP_fields + struct.pack('>B',MTS_ConfigIDFormatSelector) +bytes_config_name + struct.pack('>H',MTS_RevisionLevel) + struct.pack('>Q',int(MTS_ConfigDigest[2:18],16)) + struct.pack('>Q',int(MTS_ConfigDigest[18:34],16)) + struct.pack('>IQB',CIST_InternalRootPathCost,CIST_BridgeIdentifier,CIST_RemainingHops)

    number_of_mstids = int(param[28])

    for i in range(number_of_mstids):

        tmp_flags = param[29+6*i]
        globals()["MSTI_flags_"+str(i+1)]=int(tmp_flags.replace("-",""),2)

        tmp_BridgeID = param[30+6*i]
        rootid, rootmac = tmp_BridgeID.split('-')
        globals()["MSTI_ID_Pri_RegionalRoot"+str(i+1)] = int(rootid+rootmac.replace(":",""),16) 

        globals()["MSTI_InternalRootPathCost_"+str(i+1)] = int(param[31+6*i],16)
        globals()["MSTI_BridgeIdentifierPriority_"+str(i+1)] = int(param[32+6*i],16)
        globals()["MSTI_PortIdentifierPriority_"+str(i+1)] = int(param[33+6*i],16)
        globals()["MSTI_RemainingHops_"+str(i+1)] = int(param[34+6*i],16)

        globals()["bytes_MSTID_"+str(i+1)] = struct.pack('>BQIBBB',globals()["MSTI_flags_"+str(i+1)],globals()["MSTI_ID_Pri_RegionalRoot"+str(i+1)],globals()["MSTI_InternalRootPathCost_"+str(i+1)],globals()["MSTI_BridgeIdentifierPriority_"+str(i+1)],globals()["MSTI_PortIdentifierPriority_"+str(i+1)],globals()["MSTI_RemainingHops_"+str(i+1)])
    
        bytes_STP_fields = bytes_STP_fields + globals()["bytes_MSTID_"+str(i+1)]

        
    vlan_enabled=param[29+6*number_of_mstids]
    if vlan_enabled=="True":
        vlan_enabled="True"
        vlan_tag=param[30+6*number_of_mstids]
        vlan_pvid=param[31+6*number_of_mstids]
    else:
        vlan_enabled="False"
        vlan_tag=""
        vlan_pvid=""
    print(vlan_enabled)

    '''
    bytes_STP_fields = struct.pack('>HBBBQIQHHHHHB',ProtocolID_mstp,VersionID_mstp,BPDU_type_mstp,BPDU_flags_mstp,RootID_mstp,CostPath_mstp,BridgeID_mstp,PortID_mstp,MessageAge_mstp,MaxAge_mstp,HelloTime_mstp,ForwardDelay_mstp,Version_1_Length)
    '''
    #padding = struct.pack('>IHB',0,0,0)

    #bytes_STP_fields = bytes_STP_fields + padding

    
    print(len(bytes_STP_fields))
    print(bytes_STP_fields[102:])
    
    return vlan_enabled, vlan_tag, vlan_pvid, bytes_STP_fields
    
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
    
def VLAN_tag(vlan_tag, vlan_pvid):


    # TPID: 2 bytes

    tpid_bytes = struct.pack('>H',int(vlan_pvid, base=16))

    # PCP(3 bits) + DEI(1 bit) + VID(12 bits)
    pcp_bin_str = '{0:b}'.format( 0)
    pcp_bin_str = ''.ljust(int(3-len(pcp_bin_str)), '0') + pcp_bin_str   # "011"

    dei_bin_str = '{0:b}'.format( 0 )
    dei_bin_str = ''.ljust(int(1-len(dei_bin_str)), '0') + dei_bin_str

    vid_bin_str = '{0:b}'.format( int(vlan_tag) )
    vid_bin_str = ''.ljust(int(12-len(vid_bin_str)), '0' ) + vid_bin_str        


    fields_int = int(pcp_bin_str+dei_bin_str+vid_bin_str, 2)
    #print(fields_int)
    fields_bytes = struct.pack('>H',fields_int)

    vlan_tag_bytes = tpid_bytes+fields_bytes

    return vlan_tag_bytes 

def sendBPDUs():

    global bytes_STP_fields

    vlan_enabled, vlan_tag, vlan_pvid, bytes_STP_fields = read_MSTP_param()

    showMSTPfields()

    dsap_mstp , ssap_mstp , ctrl_mstp = getLLCfields(LLC_mstp)

    packet = Ether(dst=MAC_dst_mstp,src=MAC_src_mstp,type=ethertype_mstp)/LLC(dsap=dsap_mstp ,ssap=ssap_mstp ,ctrl=ctrl_mstp )/STP(bytes_STP_fields)
    #packet = Ether(dst=MAC_dst_mstp,type=ethertype_mstp)/LLC(dsap=dsap_mstp ,ssap=ssap_mstp ,ctrl=ctrl_mstp )/STP(bytes_STP_fields)
    pkt_bytes = bytearray(bytes(packet))
    if vlan_enabled == "true" or vlan_enabled=="True"or vlan_enabled=="TRUE":
        print("SDAF")
        vlan_tag_bytes = VLAN_tag(vlan_tag,vlan_pvid)
            #pkt_bytes[16:18] = b'\x8100'
        for j in range(4):
                pkt_bytes.insert( 12+j , vlan_tag_bytes[j] )
        c = D_mstp/interval_mstp
        array_pkts=[]
        for i in range(30):

            array_pkts.append(Raw(pkt_bytes))
        
        wrpcap("frames.pcap",array_pkts)
        time.sleep(0.5)
        pkts = rdpcap("frames.pcap")
        cooked=[]
        timestamp = 1
        for p in pkts:
            p.time = timestamp
            timestamp += 1/1000
            pmod=p
            cooked.append(pmod)
        wrpcap("frames.pcap", cooked)
        print("Interface:",interface_mstp)
        os.system("tcpreplay -i" +interface_mstp+" --duration 30 --loop 0 --pps 2 --pps-multi=2 frames.pcap")
    else:
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
            
            sendBPDUs()
        
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
    
        if sys.argv[1].lower() == "-t".lower():

            if os.path.exists(sys.argv[2]) == True:
            
                MSTP_file = sys.argv[2]                   
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

